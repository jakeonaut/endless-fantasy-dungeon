extends "PlayerGameMover.gd"

onready var pauseMenu = get_node("PauseMenu/MenuBox") if has_node("PauseMenu/MenuBox") else null
onready var hurtSound = get_node("Sounds/HurtSound")

onready var sunLight = get_node("../commonWorldEnvironment/The Sun")

onready var glitchFilter = get_node("GlitchFilter/TextureRect") if has_node("GlitchFilter/TextureRect") else null

var sprite_reset_timer = 0
var sprite_reset_limit = 3
var cameraRotationCounter = 0

func _ready():
    set_process_input(true)
    set_process(true)
    set_physics_process(true)
    if pauseMenu: pauseMenu.hide()

func wearCostume(costume):
    if costume == "normal": 
        mySprite.setNormalClothes()
    elif costume == "moth": 
        mySprite.setMothCostume()
    elif costume == "bugcatcher": 
        mySprite.setBugCatcherCostume()
    elif costume == "cleric": 
        mySprite.setClericCostume()
        jumpSound = get_node("Sounds/JumpOverallsSound")
    elif costume == "luckycat": 
        mySprite.setLuckyCatCostume()
    elif costume == "nightgown": 
        mySprite.setNightgown()
    global.memory["player_costume"] = costume
    
func bugTransform():
    pass # needs to be updated to work with hframe/vframe!!! could be a glitch or a costume ? [both?]
    
func _process(delta):
    # ._process(delta) #NOTE: this super method is called automatically 
    # https://github.com/godotengine/godot/issues/6500

    #if Input.is_action_just_pressed("ui_interact"):
    #    cameraFlash.flash()

    if Input.is_action_just_pressed("ui_glitch_left"):
        if glitchFilter: glitchFilter.visible = not glitchFilter.visible

    if Input.is_action_just_pressed("ui_accept") and not global.pauseMoveInput:
        if not global.pauseGame:
            if pauseMenu: pauseMenu.show()
            global.pauseGame = true
        else:
            if pauseMenu: pauseMenu.hide()
            global.pauseGame = false

    tryRotateCamera(delta)

    if global.pauseGame: return

    tryDieToEnemy()

    if not is_walking:
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
    if not Input.is_action_pressed("ui_ctrl"):
        if Input.is_action_pressed("ui_rotate_left"):
            cameraRotationCounter += delta
            getCamera().rotate_left((delta*66)+(cameraRotationCounter*36))
        elif Input.is_action_pressed("ui_rotate_right"):
            cameraRotationCounter += delta
            getCamera().rotate_right((delta*66)+(cameraRotationCounter*36))
        else: cameraRotationCounter = 0
    elif Input.is_action_pressed("ui_ctrl"):
        if Input.is_action_just_pressed("ui_rotate_left"):
            getCamera().rotate_left_90deg()
        elif Input.is_action_just_pressed("ui_rotate_right"):
            getCamera().rotate_right_90deg()
        
    if cameraRotationCounter > 1: cameraRotationCounter = 1
    
    if Input.is_action_pressed("ui_rotate_up"):
        getCamera().rotate_up(3*(delta*66))
    if Input.is_action_pressed("ui_rotate_down"):
        getCamera().rotate_down(3*(delta*66))

    if Input.is_action_just_pressed("ui_focus_next"):
        getCamera().toggleNext()
    if Input.is_action_just_pressed("ui_focus_forward"):
        getCamera().focusForward(facing)

func tryDieToEnemy():
    if smallInteractionArea.is_touching_enemy and not transitioning:
        hurtSound.play()
        global.pauseGame = true
        self.respawn("blink_fade")

func faceDown():
    mySprite.faceDown()

func lightsOff():
    sunLight.visible = false

func lightsOn():
    sunLight.visible = true