extends "GameMover.gd"

onready var camera = get_node("CameraY") # the "camera"
onready var smallInteractionArea = get_node("SmallInteractionArea")
onready var mySprite = get_node("Sprite3D")
onready var jumpSound = get_node("Sounds/JumpSound")

# Form variables
enum Form {
    NORMAL,
    FLOOR,
}
var form = Form.NORMAL

# Physics variables
var walk_speed = 8
var lunge_speed = 16
var is_lunging = 0
var jump_force = 20
var has_just_lunged = false
var has_just_jumped_timer = 0
var has_just_jumped_time_limit = 10
var is_walking = false
var dir = Vector3(0, 0, 0)
var facing = Vector3(0, 0, -1) #default to facing forward
var cameraRotationCounter = 0
var transitioning = false

func _ready():
    set_process_input(true)
    set_process(true)
    set_physics_process(true)

func getCamera(): return camera
func getCameraX(): return camera.get_node("CameraX")
func getTrueCamera(): return camera.get_node("CameraX/Camera")

func wearNormalClothes():
    mySprite.setNormalClothes()
func wearMothCostume():
    mySprite.setMothCostume()
func wearBugCatcherCostume():
    mySprite.setBugCatcherCostume()
func wearClericCostume():
    mySprite.setClericCostume()
    jumpSound = get_node("Sounds/JumpOverallsSound")
func wearLuckyCatCostume():
    mySprite.setLuckyCatCostume()
func wearNightgown():
    mySprite.setNightgown()

    
func floorTransform():
    mySprite.setFloorGlitch() # vframe for floorGlitch
    form = Form.FLOOR
    
func bugTransform():
    pass # needs to be updated to work with hframe/vframe!!! could be a glitch or a costume ? [both?]

# Player needs to handle her own text boxes
func _input(event):
    if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
        if is_activeTextboxMyChild():
            global.activeInteractor.interact()
            get_tree().set_input_as_handled()

func is_activeTextboxMyChild():
    var node = global.activeInteractor
    while node and node.get_node("..") != get_tree():
        if node == self: 
            return true
        node = node.get_node("..")
    return false
    
func _process(delta):
    tryRotateCamera(delta)

func tryRotateCamera(delta):
    if Input.is_action_pressed("ui_rotate_left") and not global.pauseMoveInput:
        cameraRotationCounter += delta
        getCamera().rotate_left(1+(cameraRotationCounter*18))
    elif Input.is_action_pressed("ui_rotate_right") and not global.pauseMoveInput:
        cameraRotationCounter += delta
        getCamera().rotate_right(1+(cameraRotationCounter*18))
    else: cameraRotationCounter = 0
    
    if Input.is_action_pressed("ui_rotate_up") and not global.pauseMoveInput:
        getCamera().rotate_up()
    if Input.is_action_pressed("ui_rotate_down") and not global.pauseMoveInput:
        getCamera().rotate_down()

    
func _physics_process(delta):
    .processPhysics(delta) #super

    # TODO(jaketrower): Add this to other GameMover
    if not on_ground and translation.y < -10 and not transitioning:
        global.playerJustFell = true
        print(str(lastOnGroundPoint) + ", " + str(lastOnGroundHv/4))
        global.lastOnGroundPoint = lastOnGroundPoint - (lastOnGroundHv/4)
        global.cameraRotation = getCamera().rotation_degrees.y
        # global transition scene, see res://scripts/transition.gd
        var currLevelPath = get_tree().get_root().get_node("level").filename
        transition.fade_to(currLevelPath)
        transitioning = true

# @override
func applyGravity(delta):
    if not on_ground or form != Form.FLOOR:
        .applyGravity(delta) #super

# @override
func processInputs():
    processJumpInputs()
    processHorizontalInputs()

    # TODO(jaketrower): Add this to other GameMover
    if is_walking and smallInteractionArea.is_touching_a_ladder:
        # CLIMB BABY!!!!
        vv = jump_force / 3

func processJumpInputs():
    has_just_lunged = false
    # jump
    if Input.is_action_just_pressed("ui_jump") and not global.pauseMoveInput: 
        # Jump from the ground
        if is_lunging == 0:
            vv = jump_force
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

func processHorizontalInputs():
    # Forward as seen by the camera (OpenGL convention)
    var view_forward = -getCamera().get_transform().basis.z
    var view_right = -getCamera().get_transform().basis.x
    # Forward as seen by the player
    var forward = Vector3(view_forward.x, 0.0, view_forward.z).normalized()
    var right = view_right
    
    if on_ground or has_just_jumped_timer < has_just_jumped_time_limit:
        has_just_jumped_timer += 1
        
        if on_ground or (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or \
            Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")):
            dir = Vector3(0.0, 0.0, 0.0)
            if Input.is_action_pressed("ui_left") and not global.pauseMoveInput:
                dir += right
            elif Input.is_action_pressed("ui_right") and not global.pauseMoveInput:
                dir -= right
            if Input.is_action_pressed("ui_up") and not global.pauseMoveInput:
                dir += forward
            elif Input.is_action_pressed("ui_down") and not global.pauseMoveInput:
                dir -= forward

    updateFacing(dir)
    
    # update x and z
    if is_lunging < 2:
        hv = dir.normalized() * walk_speed
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

# @override
func noFloorBelow():
    if is_on_floor():
        fallCounter = 0
        on_ground = true
    elif form != Form.FLOOR:
        on_ground = false