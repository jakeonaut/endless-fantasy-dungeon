extends "GameMover.gd"

onready var camera = get_node("CameraY") # the "camera"
onready var jumpSound = get_node("Sounds/JumpSound")
onready var doubleJumpSound = get_node("Sounds/DoubleJumpSound")
onready var wetJumpSound = get_node("Sounds/WetJumpSound")
onready var fallSound = get_node("Sounds/FallSound")
onready var smallInteractionArea = get_node("SmallInteractionArea")

# GlitchForm variables
enum GlitchForm {
    NORMAL, TWIN,
    FLOOR,
    FEATHER,
    LADDER,
    JUMP,
}
var glitch_form = GlitchForm.NORMAL
var feather_fall_timer = 0
var feather_fall_time_limit = 30
var is_holding_chicken = false
var chicken_jumps = 0

func isFeatherLike():
    return glitch_form == GlitchForm.FEATHER or is_holding_chicken

enum Equipment {
    NONE,
    SKATES,
}
var equipment = Equipment.NONE
func equipSkates(): equipment = Equipment.SKATES

# Physics variables
var recover_walk_speed = 4
var swimming_walk_speed = 6
var lunge_speed = 16
var is_lunging = 0
var should_magic_jump = false
var jump_force = 20
var weaker_jump_force = 19
var has_just_lunged = false
var has_just_jumped_timer = 0
var has_just_jumped_time_limit = 200# 3
var is_rolling = false
var rolling_timer = 0
var rolling_time_limit = 5
var should_recover = false
var is_recovering = false
var recover_timer = 0
var recover_time_limit = 3
# TODO(jaketrower): dedupe with is_pressing_horizontal_input
var is_walking = false
var is_pressing_horizontal_input = false
var was_pressing_horizontal_input = false
var facing = Vector3(0, 0, -1) #default to facing forward
var transitioning = false

var broom_timer = 0
var broom_time_limit = 2
var broom_state = 0
var can_broom = global.can_broom

func getCamera(): return camera
func getCameraX(): return camera.get_node("CameraX")
func getTrueCamera(): return camera.get_node("CameraX/Camera")

func _ready():
    set_physics_process(true)

# @override
func respawn():
    pass

# param transition name only used as a crappy enum
func playerRespawn(transition_name):
    global.isRespawning = true
    global.cameraRotation = getCamera().rotation_degrees.y
    # global transition scene, see res://scripts/transition.gd
    var currLevelPath = get_tree().get_root().get_node("level").filename
    transitioning = true

    if transition_name == "long_fade":
        transition.long_fade_to(currLevelPath)
    elif transition_name == "blink_fade":
        transition.blink_fade_to(currLevelPath)
    else:
        transition.fade_to(currLevelPath)

func _physics_process(delta):
    # ._process_physics(delta) #NOTE: this super method is called automatically 
    # https://github.com/godotengine/godot/issues/6500

    # these variables used by GameMover.gd
    self.is_touching_speed_boost = smallInteractionArea.is_touching_speed_boost
    self.speed_boost_angle = smallInteractionArea.speed_boost_angle
    self.speed_boost_origin = smallInteractionArea.speed_boost_origin

    if global.pauseGame: return

    is_touching_water = smallInteractionArea.is_touching_water

    if is_rolling:
        rolling_timer += (delta*22)
        if rolling_timer >= rolling_time_limit:
            is_rolling = false
            rolling_timer = 0
    .processPhysics(delta) #super
    if is_recovering:
        recover_timer += (delta*22)
        if recover_timer >= recover_time_limit:
            recover_timer = 0
            is_recovering = false

    if not on_ground and translation.y < (last_grounded_y - falling_y_offset) and not transitioning:
        print(str(translation.y) + ", " + str(last_grounded_y) + ", " + str(falling_y_offset))
        fallSound.play()
        self.playerRespawn("long_fade")

# @override
func applyGravity(delta):
    if is_floating:
        # somehow, a positive (upwards) gravity causes a jump (normally pushing up) to invert (push down) 
        g = Vector3(0, grav/2, 0)
        # on_ground = false
    elif smallInteractionArea.is_touching_water:
        g = Vector3(0, -grav/3, 0)
    elif self.isFeatherLike():
        g = Vector3(0, -grav/2, 0)
    elif broom_state > 0:
        g = Vector3(0, 0, 0)
        vv = 0
    else:
        g = Vector3(0, -grav, 0)

    if not on_ground or self.glitch_form != GlitchForm.FLOOR:
        lv += g * delta

# @override
func applyTerminalVelocity(delta):
    feather_fall_timer += (delta*22)
    if smallInteractionArea.is_touching_water or (
       self.glitch_form == GlitchForm.FEATHER and self.feather_fall_timer < self.feather_fall_time_limit) or \
       self.is_holding_chicken:
        terminal_vel = water_terminal_vel
    else:
        terminal_vel = true_terminal_vel

    if vv < -terminal_vel:
        vv = -terminal_vel
        fallCounter += (delta*22)

    if self.glitch_form == GlitchForm.FLOOR and on_ground:
        vv = 0

# @override
func processInputs(delta):
    processJumpInputs(delta)
    processHorizontalInputs(delta)

    if self.isWalkingIntoWall() and (smallInteractionArea.is_touching_a_ladder or \
       (glitch_form == GlitchForm.LADDER and was_pressing_horizontal_input)):
        # CLIMB BABY!!!!
        vv = jump_force / 3
    was_pressing_horizontal_input = is_pressing_horizontal_input

func magicJump():
    should_magic_jump = true

func isWalkingIntoWall():
    return linear_velocity.x < 2 and linear_velocity.x > -2 \
            and linear_velocity.z < 2 and linear_velocity.z > -2 \
            and self.is_pressing_horizontal_input

func isSkateWallJumpInput():
    # self.is_pressing_horizontal_input = (Input.is_action_pressed("ui_left") or 
    #                                      Input.is_action_pressed("ui_right") or 
    #                                      Input.is_action_pressed("ui_up") or 
    #                                      Input.is_action_pressed("ui_down"))
    # # Forward as "seen" by the camera (OpenGL convention)
    # var view_forward = -getCamera().get_transform().basis.z
    # var view_right = -getCamera().get_transform().basis.x
    # # Forward as "seen" by the player
    # var forward = Vector3(view_forward.x, 0.0, view_forward.z).normalized()
    # var right = view_right
    

    # REAL SOLUTION:
    # need to check if horizontal input is perpindicular the wall
    # by using the forward / right vectors against the linear velocity.x/z that is closest to zero
    # and using the forward / right vectors against the "horizontal" input
    return self.equipment == Equipment.SKATES and self.isWalkingIntoWall() and not on_ground

func processJumpInputs(delta):
    has_just_lunged = false

    # jump
    if (Input.is_action_just_pressed("ui_jump") or should_magic_jump) and not global.pauseMoveInput: 
        # Jump from the water
        if smallInteractionArea.is_touching_water or self.is_holding_chicken and self.chicken_jumps < 1:
            is_recovering = false
            if is_floating:
                vv = -jump_force / 2
            else:
                vv = jump_force / 2

            if smallInteractionArea.is_touching_water:
                wetJumpSound.play()
            else: 
                jumpSound.play()
            on_ground = false
            has_just_jumped_timer = -has_just_jumped_time_limit
            is_lunging = -1
            feather_fall_timer = 0
            chicken_jumps += 1
        # Jump from the ground
        elif is_lunging == 0 or should_magic_jump or (glitch_form == GlitchForm.JUMP && fallCounter >= fallCountMin):
            is_recovering = false
            var curr_jump_force = jump_force
            # a11y hack for jessica. if walking into a wall, make it a bit easier to jump right on it
            if self.isWalkingIntoWall():
                curr_jump_force = weaker_jump_force
                should_recover = true
            vv = curr_jump_force

            jumpSound.play()
            on_ground = false
            is_lunging = -1
            has_just_jumped_timer = 0
            feather_fall_timer = 0
        # Dash lunge
        elif is_lunging == 1:
            vv = jump_force / 2
            jumpSound.play()
            has_just_lunged = true
            is_lunging = 2
            has_just_jumped_timer = 0
            feather_fall_timer = 0
        # Double jump
        elif (is_lunging == -1 or self.isSkateWallJumpInput()) and not glitch_form == GlitchForm.JUMP:
            vv = jump_force / 1.5
            doubleJumpSound.play()
            is_lunging = -2
            if self.isSkateWallJumpInput():
                is_lunging = -1
            has_just_jumped_timer = 0
            feather_fall_timer = 0
            startRotateSprite(1)
        should_magic_jump = false
    elif take_fall_damage and self.glitch_form != GlitchForm.FLOOR:
        vv = (2*jump_force)/3
        take_fall_damage = false
        on_ground = false

    if is_touching_water:
        if Input.is_action_just_pressed("ui_jump") and not global.pauseMoveInput:
            float_timer = 0
            is_floating = false
        elif Input.is_action_pressed("ui_jump") and not global.pauseMoveInput:
            float_timer += (delta*22)
            if float_timer >= big_float_time_limit:
                is_floating = true
                float_timer = 0
        elif not Input.is_action_pressed("ui_jump"):
            float_timer += (delta*22)
            if on_ground:
                is_floating = true
                float_timer = 0
            elif float_timer >= big_float_time_limit:
                is_floating = false
                float_timer = 0
    else: 
        is_floating = false
        float_timer = 0
        if Input.is_action_pressed("ui_jump") and was_touching_water and not global.pauseMoveInput:
            is_recovering = false
            vv = (3*jump_force) / 5

            on_ground = false
            jumpSound.play()
            has_just_jumped_timer = -has_just_jumped_time_limit

const PROJECTION_ORTHOGONAL = 1
func processHorizontalInputs(delta):
    self.is_pressing_horizontal_input = (Input.is_action_pressed("ui_left") or 
                                         Input.is_action_pressed("ui_right") or 
                                         Input.is_action_pressed("ui_up") or 
                                         Input.is_action_pressed("ui_down"))

    # Forward as "seen" by the camera (OpenGL convention)
    var view_forward = -getCamera().get_transform().basis.z
    var view_right = -getCamera().get_transform().basis.x
    # Forward as "seen" by the player
    var forward = Vector3(view_forward.x, 0.0, view_forward.z).normalized()
    var right = view_right

    # snap movement to right angles
    if getTrueCamera().get_projection() == PROJECTION_ORTHOGONAL:
        if abs(forward.z) > abs(forward.x):
            if forward.z < 0:
                forward = Vector3(0, 0, -1)
                right = Vector3(-1, 0, 0)
            else:
                forward = Vector3(0, 0, 1)
                right = Vector3(1, 0, 0)
        else:
            if forward.x < 0:
                forward = Vector3(-1, 0, 0)
                right = Vector3(0, 0, 1)
            else:
                forward = Vector3(1, 0, 0)
                right = Vector3(0, 0, -1)

    if self.glitch_form == GlitchForm.FEATHER or (self.is_holding_chicken and not on_ground):
        forward = forward / 4
        right = right / 4

    if self.equipment == Equipment.SKATES and not self.isSkateWallJumpInput():
        forward = forward / 10
        right = right / 10

    if self.isSkateWallJumpInput():
        forward = forward * 2
        right = right * 2
    
    var horizontal_input = false
    # I'm on the ground or just fell off a platform...
    var kind_of_on_ground = on_ground or (
        was_just_on_ground_timer <= was_just_on_ground_time_limit and vv < 0)
    has_just_jumped_timer += (delta*22)
        
    if kind_of_on_ground or has_just_jumped_timer < has_just_jumped_time_limit or \
        (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or \
        Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")) or \
        self.isFeatherLike() or self.glitch_form == GlitchForm.LADDER or self.equipment == Equipment.SKATES:
        
        horizontal_input = true
        if self.glitch_form != GlitchForm.FEATHER and (not self.is_holding_chicken or on_ground) and \
           self.equipment != Equipment.SKATES and not self.isSkateWallJumpInput():
            dir = Vector3(0.0, 0.0, 0.0)

        if Input.is_action_pressed("ui_up"):
            if not global.pauseMoveInput: 
                dir += forward
            # only change sprite facing if i'm idle of if I just pressed this
            if broom_state == 0 and (not is_walking or Input.is_action_just_pressed("ui_up") or Input.is_action_just_released("ui_down") or \
                (not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"))) and not is_rotating:
                mySprite.faceUp()
        elif Input.is_action_pressed("ui_down"):
            if not global.pauseMoveInput: 
                dir -= forward
            # only change sprite facing if i'm idle or if I just pressed down, or was holding down and released up
            if broom_state == 0 and (not is_walking or Input.is_action_just_pressed("ui_down") or Input.is_action_just_released("ui_up") or \
                (not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"))) and not is_rotating:
                mySprite.faceDown()
                
        if Input.is_action_pressed("ui_left"):
            if not global.pauseMoveInput: 
                dir += right
            # only change sprite facing if i'm idle of if I just pressed this
            if broom_state == 0 and (not is_walking or Input.is_action_just_pressed("ui_left") or Input.is_action_just_released("ui_right") or \
                (not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"))) and not is_rotating:
                mySprite.faceLeft()
            # getCamera().rotate_right(5)
        elif Input.is_action_pressed("ui_right"):
            if not global.pauseMoveInput: 
                dir -= right
            # only change sprite facing if i'm idle or if I just pressed right, or was holding right and released left
            if broom_state == 0 and (not is_walking or Input.is_action_just_pressed("ui_right") or Input.is_action_just_released("ui_left") or \
                (not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"))) and not is_rotating:
                mySprite.faceRight()
            # getCamera().rotate_left(5)

    if self.isFeatherLike() or self.equipment == Equipment.SKATES:
        if self.isFeatherLike() and dir.length() > 1:
            dir = dir.normalized()
        if self.equipment == Equipment.SKATES and dir.length() > 2:
            dir = dir.normalized()
        if on_ground and not self.is_pressing_horizontal_input:
            dir = dir * 0.9
            if dir.length() < 0.1:
                dir = Vector3(0, 0, 0)

    var curr_walk_speed = walk_speed
    if smallInteractionArea.is_touching_water or (not on_ground and self.isFeatherLike()):
        curr_walk_speed = swimming_walk_speed
    elif is_recovering or should_recover or (not on_ground and self.glitch_form == GlitchForm.LADDER):
        curr_walk_speed = recover_walk_speed

    if is_rolling:
        curr_walk_speed = curr_walk_speed * 3
        if dir.x == 0 and dir.y == 0 and dir.z == 0:
            dir = prev_dir

    # update x and z
    if is_lunging < 2 and (not smallInteractionArea.is_touching_water or horizontal_input):
        hv = dir * curr_walk_speed
    if has_just_lunged:
        hv = dir * lunge_speed

    if broom_state > 0:
        hv = Vector3(0, 0, 0)
        is_walking = false
    else:
        updateFacing(dir)

func updateFacing(dir):
    if dir.x != 0 or dir.y != 0 or dir.z != 0:
        facing = dir
        is_walking = true
    else:
        is_walking = false

# @override
func landed():
    is_lunging = 0
    .landed() #super

# @override
func noFloorBelow():
    if is_on_floor():
        fallCounter = 0
        feather_fall_timer = 0
        on_ground = true
        self.chicken_jumps = 0
        if should_recover:
            is_recovering = true
            should_recover = false
    elif self.glitch_form != GlitchForm.FLOOR and broom_state <= 0:
        on_ground = false