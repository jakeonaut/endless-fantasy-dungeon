extends "PlayerGameMover.gd"

onready var pauseMenu = get_node("PauseMenu/MenuBox")
onready var hurtSound = get_node("Sounds/HurtSound")

onready var sunLight = get_node("Lights/The Sun")
onready var ambientLight = get_node("CameraY/CameraX/Ambient")

var sprite_reset_timer = 0
var sprite_reset_limit = 3
var cameraRotationCounter = 0

func _ready():
    set_process_input(true)
    set_process(true)
    set_physics_process(true)
    pauseMenu.hide()

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

    tryRotateCamera(delta)
    if Input.is_action_just_pressed("ui_focus_next"):
        getCamera().toggleNext()
    if Input.is_action_just_pressed("ui_focus_forward"):
        getCamera().focusForward(facing)

    if global.pauseGame: return

    tryDieToEnemy()

    if not sprite_facing:
        sprite_reset_timer += delta
        if sprite_reset_timer >= sprite_reset_limit and not mySprite.isFacingDown():
            mySprite.faceDown()
    else:
        sprite_reset_timer = 0

func _physics_process(delta):
    # ._process_physics(delta) #NOTE: this super method is called automatically 
    # https://github.com/godotengine/godot/issues/6500
    pass

func tryRotateCamera(delta):
    if Input.is_action_pressed("ui_rotate_left"):
        cameraRotationCounter += delta
        getCamera().rotate_left((delta*66)+(cameraRotationCounter*36))
    elif Input.is_action_pressed("ui_rotate_right"):
        cameraRotationCounter += delta
        getCamera().rotate_right((delta*66)+(cameraRotationCounter*36))
    else: cameraRotationCounter = 0
        
    if cameraRotationCounter > 1: cameraRotationCounter = 1
    
    if Input.is_action_pressed("ui_rotate_up"):
        getCamera().rotate_up(3*(delta*66))
    if Input.is_action_pressed("ui_rotate_down"):
        getCamera().rotate_down(3*(delta*66))

func tryDieToEnemy():
    if smallInteractionArea.is_touching_enemy and not transitioning:
        hurtSound.play()
        global.pauseGame = true
        self.respawn("blink_fade")

func faceDown():
    mySprite.faceDown()

func lightsOff():
    sunLight.visible = false
    ambientLight.visible = false

func lightsOn():
    sunLight.visible = true
    ambientLight.visible = true