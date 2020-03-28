extends "GameMover.gd"

onready var camera = get_node("CameraY") # the "camera"
onready var jumpSound = get_node("Sounds/JumpSound")
onready var fallSound = get_node("Sounds/FallSound")
onready var smallInteractionArea = get_node("SmallInteractionArea")

# GlitchForm variables
enum GlitchForm {
    NORMAL, TWIN,
    FLOOR,
    FEATHER,
    LADDER,
}
var glitch_form = GlitchForm.NORMAL
var feather_fall_timer = 0
var feather_fall_time_limit = 30

# Physics variables
var recover_walk_speed = 4
var swimming_walk_speed = 6
var is_swamp_hopping = false
var swamp_hop_counter = 0
var swamp_hop_count_limit = 3
var lunge_speed = 16
var is_lunging = 0
var jump_force = 20
var weaker_jump_force = 19
var has_just_lunged = false
var has_just_jumped_timer = 0
var has_just_jumped_time_limit = 3
var should_recover = false
var is_recovering = false
var recover_timer = 0
var recover_time_limit = 3
# TODO(jaketrower): dedupe with is_pressing_horizontal_input
var is_walking = false
var is_pressing_horizontal_input = false
var was_pressing_horizontal_input = false
var facing = Vector3(0, 0, -1) #default to facing forward
var sprite_facing = false
var transitioning = false

func getCamera(): return camera
func getCameraX(): return camera.get_node("CameraX")
func getTrueCamera(): return camera.get_node("CameraX/Camera")

func _ready():
    set_physics_process(true)

# param transition name only used as a crappy enum
func respawn(transition_name):
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
    if not was_touching_water and is_touching_water and swamp_hop_counter < swamp_hop_count_limit \
       and smallInteractionArea.water_y < global_transform.origin.y + 0.5:
        is_swamp_hopping = true
        take_fall_damage = true
        swamp_hop_counter += 1
        if swamp_hop_counter == swamp_hop_count_limit:
            self.startRotateSprite(1)
        if bumpSound:
            bumpSound.play()

    .processPhysics(delta) #super
    if is_recovering:
        recover_timer += (delta*22)
        if recover_timer >= recover_time_limit:
            recover_timer = 0
            is_recovering = false

    if not on_ground and translation.y < -6 and not transitioning:
        fallSound.play()
        self.respawn("long_fade")

# @override
func applyGravity(delta):
    if is_floating:
        g = Vector3(0, grav/2, 0)
        on_ground = false
    elif smallInteractionArea.is_touching_water or self.glitch_form == GlitchForm.FEATHER:
        g = Vector3(0, -grav/2, 0)
    else:
        g = Vector3(0, -grav, 0)

    if not on_ground or self.glitch_form != GlitchForm.FLOOR:
        lv += g * delta

# @override
func applyTerminalVelocity(delta):
    feather_fall_timer += (delta*22)
    if smallInteractionArea.is_touching_water or (
       self.glitch_form == GlitchForm.FEATHER and feather_fall_timer < feather_fall_time_limit):
        terminal_vel = water_terminal_vel
    else:
        terminal_vel = true_terminal_vel

    if vv < -terminal_vel:
        vv = -terminal_vel
        fallCounter += (delta*22)

# @override
func processInputs(delta):
    processJumpInputs(delta)
    processHorizontalInputs(delta)

    if self.isWalkingIntoWall() and (smallInteractionArea.is_touching_a_ladder or \
       (glitch_form == GlitchForm.LADDER and was_pressing_horizontal_input)):
        # CLIMB BABY!!!!
        vv = jump_force / 3
    was_pressing_horizontal_input = is_pressing_horizontal_input

func isWalkingIntoWall():
    return linear_velocity.x < 2 and linear_velocity.x > -2 \
            and linear_velocity.z < 2 and linear_velocity.z > -2 \
            and self.is_pressing_horizontal_input

func processJumpInputs(delta):
    has_just_lunged = false
    # jump
    if Input.is_action_just_pressed("ui_jump") and not is_swamp_hopping and not global.pauseMoveInput: 
        # Jump from the water
        if smallInteractionArea.is_touching_water:
            on_ground = false
            is_recovering = false
            vv = (2*jump_force) / 3
            jumpSound.play()
            has_just_jumped_timer = -has_just_jumped_time_limit
            is_lunging = 0
            swamp_hop_counter = swamp_hop_count_limit
            feather_fall_timer = 0
        # Jump from the ground
        elif is_lunging == 0:
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
        elif is_lunging == -1:
            vv = jump_force / 1.5
            jumpSound.play()
            is_lunging = -2
            has_just_jumped_timer = 0
            feather_fall_timer = 0
    elif take_fall_damage and self.glitch_form != GlitchForm.FLOOR:
        vv = (2*jump_force)/3
        take_fall_damage = false
        on_ground = false

    if not is_swamp_hopping:
        if is_touching_water:
            if Input.is_action_pressed("ui_jump") and not global.pauseMoveInput:
                float_timer += (delta*22)
                if float_timer >= big_float_time_limit:
                    is_floating = true
            elif not Input.is_action_pressed("ui_jump"):
                is_floating = false
                float_timer = 0
        else: 
            is_floating = false
            float_timer = 0
            if Input.is_action_pressed("ui_jump") and was_touching_water and not global.pauseMoveInput:
                on_ground = false
                is_recovering = false
                vv = jump_force
                jumpSound.play()
                has_just_jumped_timer = -has_just_jumped_time_limit
                is_lunging = 0

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

    if self.glitch_form == GlitchForm.FEATHER:
        forward = forward / 4
        right = right / 4
    
    var horizontal_input = false
    if on_ground or has_just_jumped_timer < has_just_jumped_time_limit or \
       smallInteractionArea.is_touching_water or self.glitch_form == GlitchForm.FEATHER or \
       self.glitch_form == GlitchForm.LADDER:
        has_just_jumped_timer += (delta*22)
        
        if on_ground or (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or \
           Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")) or \
           self.glitch_form == GlitchForm.FEATHER or self.glitch_form == GlitchForm.LADDER:
            horizontal_input = true
            if self.glitch_form != GlitchForm.FEATHER:
                dir = Vector3(0.0, 0.0, 0.0)
            if Input.is_action_pressed("ui_left"):
                if not global.pauseMoveInput: 
                    dir += right
                # only change sprite facing if i'm idle of if I just pressed this
                if not sprite_facing or Input.is_action_just_pressed("ui_left"):
                    sprite_facing = true
                    mySprite.faceLeft()
                # getCamera().rotate_right(5)
            elif Input.is_action_pressed("ui_right"):
                if not global.pauseMoveInput: 
                    dir -= right
                # only change sprite facing if i'm idle or if I just pressed right, or was holding right and released left
                if not sprite_facing or Input.is_action_just_pressed("ui_right") or Input.is_action_just_released("ui_left"):
                    sprite_facing = true
                    mySprite.faceRight()
                # getCamera().rotate_left(5)
            else: sprite_facing = "" # need to reset facing left and right if I'm holding walking up or down

            if Input.is_action_pressed("ui_up"):
                if not global.pauseMoveInput: 
                    dir += forward
                # only change sprite facing if i'm idle of if I just pressed this
                if not sprite_facing or Input.is_action_just_pressed("ui_up"):
                    sprite_facing = true
                    mySprite.faceUp()
            elif Input.is_action_pressed("ui_down"):
                if not global.pauseMoveInput: 
                    dir -= forward
                # only change sprite facing if i'm idle or if I just pressed down, or was holding down and released up
                if not sprite_facing or Input.is_action_just_pressed("ui_down") or Input.is_action_just_released("ui_up"):
                    sprite_facing = true
                    mySprite.faceDown()

    if self.glitch_form == GlitchForm.FEATHER:
        if dir.length() > 1:
            dir = dir.normalized()
        if on_ground and not self.is_pressing_horizontal_input:
            dir = dir * 0.9
            if dir.length() < 0.1:
                dir = Vector3(0, 0, 0)

    updateFacing(dir)
    var curr_walk_speed = walk_speed
    if smallInteractionArea.is_touching_water or (not on_ground and self.glitch_form == GlitchForm.FEATHER):
        curr_walk_speed = swimming_walk_speed
    elif is_recovering or should_recover or (not on_ground and self.glitch_form == GlitchForm.LADDER):
        curr_walk_speed = recover_walk_speed

    # update x and z
    if is_lunging < 2 and (not smallInteractionArea.is_touching_water or horizontal_input):
        hv = dir * curr_walk_speed
    if has_just_lunged:
        hv = dir * lunge_speed

func updateFacing(dir):
    if dir.x != 0 or dir.y != 0 or dir.z != 0:
        facing = dir
        is_walking = true
    else:
        is_walking = false
        sprite_facing = false

# @override
func landed():
    is_lunging = 0
    .landed() #super
    swamp_hop_counter = 0
    is_swamp_hopping = false

# @override
func noFloorBelow():
    if is_on_floor():
        fallCounter = 0
        feather_fall_timer = 0
        on_ground = true
        if should_recover:
            is_recovering = true
            should_recover = false
        if is_touching_water:
            is_floating = true
    elif self.glitch_form != GlitchForm.FLOOR:
        on_ground = false