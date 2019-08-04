extends "GameMover.gd"

var is_stone = false

# player is my parent for purposes of scripting
onready var camera = get_node("../Player/CameraY") # the "camera"
onready var jumpSound = get_node("Sounds/JumpSound")
onready var fallSound = get_node("Sounds/FallSound")
# onready var smallInteractionArea = get_node("SmallInteractionArea")

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
var is_walking = false
var facing = Vector3(0, 0, -1) #default to facing forward
var transitioning = false

func getCamera(): return camera

func _ready():
    set_physics_process(true)

# param transition name only used as a crappy enum
func respawn(transition_name):
    transitioning = true
    if transition_name == "long_fade":
        pass
    elif transition_name == "blink_fade":
        pass
    else:
        pass

func _physics_process(delta):
    # ._process_physics(delta) #NOTE: this super method is called automatically 
    # https://github.com/godotengine/godot/issues/6500  

    if not visible or global.pauseGame or is_stone: return

    # TODO(jaketrower):
    #is_touching_water = smallInteractionArea.is_touching_water
    # if not was_touching_water and is_touching_water and swamp_hop_counter < swamp_hop_count_limit \
    #    and smallInteractionArea.water_y < global_transform.origin.y + 0.5:
    #     is_swamp_hopping = true
    #     take_fall_damage = true
    #     swamp_hop_counter += 1
    #     if swamp_hop_counter == swamp_hop_count_limit:
    #         self.startRotateSprite(1)
    #     if bumpSound:
    #         bumpSound.play()

    .processPhysics(delta) #super
    if is_recovering:
        recover_timer += (delta*22)
        if recover_timer >= recover_time_limit:
            recover_timer = 0
            is_recovering = false

    # TODO(jaketrower): Add this to other GameMover
    if not on_ground and translation.y < -6 and not transitioning:
        fallSound.play()
        self.respawn("long_fade")

# @override
func applyGravity(delta):
    if is_floating:
        g = Vector3(0, grav/2, 0)
        on_ground = false
    # elif smallInteractionArea.is_touching_water:
    #     g = Vector3(0, -grav/2, 0)
    else:
        g = Vector3(0, -grav, 0)

    lv += g * delta

# @override
func applyTerminalVelocity(delta):
    # if smallInteractionArea.is_touching_water:
    #     terminal_vel = water_terminal_vel
    # else:
    terminal_vel = true_terminal_vel

    if vv < -terminal_vel:
        vv = -terminal_vel
        fallCounter += (delta*22)

# @override
func processInputs(delta):
    processJumpInputs(delta)
    processHorizontalInputs(delta)

    # TODO(jaketrower): Add this to other GameMover
    # if is_walking and smallInteractionArea.is_touching_a_ladder:
    #     # CLIMB BABY!!!!
    #     vv = jump_force / 3

func processJumpInputs(delta):
    has_just_lunged = false
    # jump
    if Input.is_action_just_pressed("ui_jump") and not is_swamp_hopping and not global.pauseMoveInput: 
        # Jump from the water
        # if smallInteractionArea.is_touching_water:
        #     on_ground = false
        #     is_recovering = false
        #     vv = (2*jump_force) / 3
        #     jumpSound.play()
        #     has_just_jumped_timer = -has_just_jumped_time_limit
        #     is_lunging = 0
        #     swamp_hop_counter = swamp_hop_count_limit
        # Jump from the ground
        if is_lunging == 0:
            is_recovering = false
            var curr_jump_force = jump_force
            # a11y hack for jessica. if walking into a wall, make it a bit easier to jump right on it
            if linear_velocity.x < walk_speed/2 and linear_velocity.x > -walk_speed/2 \
            and linear_velocity.z < walk_speed/2 and linear_velocity.z > -walk_speed/2 \
            and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") \
            or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")):
                curr_jump_force = weaker_jump_force
                should_recover = true
            vv = curr_jump_force

            jumpSound.play()
            on_ground = false
            is_lunging = -1
            has_just_jumped_timer = 0
        # Dash lunge
        elif is_lunging == 1:
            vv = jump_force / 2
            jumpSound.play()
            has_just_lunged = true
            is_lunging = 2
            has_just_jumped_timer = 0
        # Double jump
        elif is_lunging == -1:
            vv = jump_force / 1.5
            jumpSound.play()
            is_lunging = -2
            has_just_jumped_timer = 0
    elif take_fall_damage:
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

func processHorizontalInputs(delta):
    # Forward as "seen" by the camera (OpenGL convention)
    var view_forward = -getCamera().get_transform().basis.z
    var view_right = -getCamera().get_transform().basis.x
    # Forward as "seen" by the player
    var forward = Vector3(view_forward.x, 0.0, view_forward.z).normalized()
    var right = view_right

    # snap movement to right angles
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
    
    var horizontal_input = false
    if on_ground or has_just_jumped_timer < has_just_jumped_time_limit: # or smallInteractionArea.is_touching_water:
        has_just_jumped_timer += (delta*22)
        
        if on_ground or (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or \
            Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")):
            horizontal_input = true
            dir = Vector3(0.0, 0.0, 0.0)
            if Input.is_action_pressed("ui_right"):
                if not global.pauseMoveInput: 
                    dir += right
                mySprite.faceLeft()
            elif Input.is_action_pressed("ui_left"):
                if not global.pauseMoveInput: 
                    dir -= right
                mySprite.faceRight()

            if Input.is_action_pressed("ui_down"):
                if not global.pauseMoveInput: 
                    dir += forward
                mySprite.faceUp()
            elif Input.is_action_pressed("ui_up"):
                if not global.pauseMoveInput: 
                    dir -= forward
                mySprite.faceDown()

    updateFacing(dir)
    var curr_walk_speed = walk_speed
    # if smallInteractionArea.is_touching_water:
    #     curr_walk_speed = swimming_walk_speed
    if is_recovering or should_recover:
        curr_walk_speed = recover_walk_speed

    # update x and z
    if is_lunging < 2 and horizontal_input: #(not smallInteractionArea.is_touching_water or horizontal_input):
        hv = dir.normalized() * curr_walk_speed
    if has_just_lunged:
        hv = dir.normalized() * lunge_speed

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
    swamp_hop_counter = 0
    is_swamp_hopping = false

# @override
func noFloorBelow():
    if is_on_floor():
        fallCounter = 0
        on_ground = true
        if should_recover:
            is_recovering = true
            should_recover = false
    else:
        on_ground = false