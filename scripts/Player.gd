extends "GameMover.gd"

onready var camera = get_node("CameraY") # the "camera"
onready var pauseMenu = get_node("PauseMenu/MenuBox")
onready var smallInteractionArea = get_node("SmallInteractionArea")
onready var mySprite = get_node("Sprite3D")
onready var jumpSound = get_node("Sounds/JumpSound")
onready var fallSound = get_node("Sounds/FallSound")
onready var hurtSound = get_node("Sounds/HurtSound")

# Form variables
enum Form {
    NORMAL,
    FLOOR,
}
var form = Form.NORMAL

# Physics variables
var walk_speed = 8
var recover_walk_speed = 4
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
var dir = Vector3(0, 0, 0)
var facing = Vector3(0, 0, -1) #default to facing forward
var sprite_facing = ""
var sprite_reset_timer = 0
var sprite_reset_limit = 3
var cameraRotationCounter = 0
var transitioning = false

func _ready():
    set_process_input(true)
    set_process(true)
    set_physics_process(true)
    pauseMenu.hide()

func getCamera(): return camera
func getCameraX(): return camera.get_node("CameraX")
func getTrueCamera(): return camera.get_node("CameraX/Camera")

func wearCostume(costume):
    if costume == "normal": wearNormalClothes()
    elif costume == "moth": wearMothCostume()
    elif costume == "bugcatcher": wearBugCatcherCostume()
    elif costume == "cleric": wearClericCostume()
    elif costume == "luckycat": wearLuckyCatCostume()
    elif costume == "nightgown": wearNightgown()
func wearNormalClothes():
    mySprite.setNormalClothes()
    global.memory["player_costume"] = "normal"
func wearMothCostume():
    mySprite.setMothCostume()
    global.memory["player_costume"] = "moth"
func wearBugCatcherCostume():
    mySprite.setBugCatcherCostume()
    global.memory["player_costume"] = "bugcatcher"
func wearClericCostume():
    mySprite.setClericCostume()
    jumpSound = get_node("Sounds/JumpOverallsSound")
    global.memory["player_costume"] = "cleric"
func wearLuckyCatCostume():
    mySprite.setLuckyCatCostume()
    global.memory["player_costume"] = "luckycat"
func wearNightgown():
    mySprite.setNightgown()
    global.memory["player_costume"] = "nightgown"

    
func floorTransform():
    mySprite.setFloorGlitch() # vframe for floorGlitch
    form = Form.FLOOR
    
func bugTransform():
    pass # needs to be updated to work with hframe/vframe!!! could be a glitch or a costume ? [both?]
    
func _process(delta):
    # ._process(delta) #NOTE: this super method is called automatically 
    # https://github.com/godotengine/godot/issues/6500

    if Input.is_action_just_pressed("ui_accept") and not global.pauseMoveInput:
        if not global.pauseGame:
            pauseMenu.show()
            global.pauseGame = true
        else:
            pauseMenu.hide()
            global.pauseGame = false

    if global.pauseGame: return

    tryDieToEnemy()
    tryRotateCamera(delta)
    if Input.is_action_just_pressed("ui_focus_next"):
        getCamera().toggleNext()

    if sprite_facing == "":
        sprite_reset_timer += delta
        if sprite_reset_timer >= sprite_reset_limit and not mySprite.isFacingDown():
            mySprite.faceDown()
    else:
        sprite_reset_timer = 0
        
func tryDieToEnemy():
    if smallInteractionArea.is_touching_enemy and not transitioning:
        global.isRespawning = true
        global.cameraRotation = getCamera().rotation_degrees.y
        hurtSound.play()
        # global transition scene, see res://scripts/transition.gd
        var currLevelPath = get_tree().get_root().get_node("level").filename
        transition.fade_to(currLevelPath)
        transitioning = true

func tryRotateCamera(delta):
    if Input.is_action_pressed("ui_rotate_left") and not global.pauseMoveInput:
        cameraRotationCounter += delta
        getCamera().rotate_left((delta*66)+(cameraRotationCounter*36))
    elif Input.is_action_pressed("ui_rotate_right") and not global.pauseMoveInput:
        cameraRotationCounter += delta
        getCamera().rotate_right((delta*66)+(cameraRotationCounter*36))
    else: cameraRotationCounter = 0
    
    if Input.is_action_pressed("ui_rotate_up") and not global.pauseMoveInput:
        getCamera().rotate_up(3*(delta*66))
    if Input.is_action_pressed("ui_rotate_down") and not global.pauseMoveInput:
        getCamera().rotate_down(3*(delta*66))
    
func _physics_process(delta):
    # ._process_physics(delta) #NOTE: this super method is called automatically 
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    .processPhysics(delta) #super
    if is_recovering:
        recover_timer += (delta*22)
        if recover_timer >= recover_time_limit:
            recover_timer = 0
            is_recovering = false

    # TODO(jaketrower): Add this to other GameMover
    if not on_ground and translation.y < -6 and not transitioning:
        global.isRespawning = true
        global.cameraRotation = getCamera().rotation_degrees.y
        fallSound.play()
        # global transition scene, see res://scripts/transition.gd
        var currLevelPath = get_tree().get_root().get_node("level").filename
        transition.long_fade_to(currLevelPath)
        transitioning = true

# @override
func applyGravity(delta):
    if not on_ground or form != Form.FLOOR:
        .applyGravity(delta) #super

# @override
func processInputs(delta):
    processJumpInputs(delta)
    processHorizontalInputs(delta)

    # TODO(jaketrower): Add this to other GameMover
    if is_walking and smallInteractionArea.is_touching_a_ladder:
        # CLIMB BABY!!!!
        vv = jump_force / 3

func processJumpInputs(delta):
    has_just_lunged = false
    # jump
    if Input.is_action_just_pressed("ui_jump") and not global.pauseMoveInput: 
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
    elif take_fall_damage and form != Form.FLOOR:
        vv = jump_force
        take_fall_damage = false
        on_ground = false

func processHorizontalInputs(delta):
    # Forward as seen by the camera (OpenGL convention)
    var view_forward = -getCamera().get_transform().basis.z
    var view_right = -getCamera().get_transform().basis.x
    # Forward as seen by the player
    var forward = Vector3(view_forward.x, 0.0, view_forward.z).normalized()
    var right = view_right
    
    if on_ground or has_just_jumped_timer < has_just_jumped_time_limit:
        has_just_jumped_timer += (delta*22)
        
        if on_ground or (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or \
            Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")):
            dir = Vector3(0.0, 0.0, 0.0)
            if Input.is_action_pressed("ui_left"):
                if not global.pauseMoveInput: 
                    dir += right
                # only change sprite facing if i'm idle of if I just pressed this
                if sprite_facing == "" or Input.is_action_just_pressed("ui_left"):
                    sprite_facing = "left"
                # getCamera().rotate_right(5)
            elif Input.is_action_pressed("ui_right"):
                if not global.pauseMoveInput: 
                    dir -= right
                # only change sprite facing if i'm idle or if I just pressed right, or was holding right and released left
                if sprite_facing == "" or Input.is_action_just_pressed("ui_right") or Input.is_action_just_released("ui_left"):
                    sprite_facing = "right"
                # getCamera().rotate_left(5)
            else: sprite_facing = "" # need to reset facing left and right if I'm holding walking up or down

            if Input.is_action_pressed("ui_up"):
                if not global.pauseMoveInput: 
                    dir += forward
                # only change sprite facing if i'm idle of if I just pressed this
                if sprite_facing == "" or Input.is_action_just_pressed("ui_up"):
                    sprite_facing = "up"
            elif Input.is_action_pressed("ui_down"):
                if not global.pauseMoveInput: 
                    dir -= forward
                # only change sprite facing if i'm idle or if I just pressed down, or was holding down and released up
                if sprite_facing == "" or Input.is_action_just_pressed("ui_down") or Input.is_action_just_released("ui_up"):
                    sprite_facing = "down"

            # only do final sprite change at end of conditional so that sprite "remembers" which way it was previously facing.
            # otherwise, glitches on initial frame when walking diagonally
            if sprite_facing == "left": mySprite.faceLeft()
            elif sprite_facing == "right": mySprite.faceRight()
            elif sprite_facing == "up": mySprite.faceUp()
            elif sprite_facing == "down": mySprite.faceDown()
    updateFacing(dir)
    var curr_walk_speed = walk_speed
    if is_recovering or should_recover:
        curr_walk_speed = recover_walk_speed

    # update x and z
    if is_lunging < 2:
        hv = dir.normalized() * curr_walk_speed
    if has_just_lunged:
        hv = dir.normalized() * lunge_speed

func updateFacing(dir):
    if dir.x != 0 or dir.y != 0 or dir.z != 0:
        facing = dir
        is_walking = true
    else:
        is_walking = false
        sprite_facing = ""

# @override
func landed():
    is_lunging = 0
    .landed() #super

# @override
func noFloorBelow():
    if is_on_floor():
        fallCounter = 0
        on_ground = true
        if should_recover:
            is_recovering = true
            should_recover = false
    elif form != Form.FLOOR:
        on_ground = false