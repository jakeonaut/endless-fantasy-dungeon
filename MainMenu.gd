extends "res://scripts/levelScript.gd"

func _ready():
    # ._ready() #super
    set_process(true)

    player.getCamera().toggleNext()
    global.pauseGame = true
    global.pauseMoveInput = true

func _process(delta):
    # rotate camera slowly
    player.getCamera().rotateTo(player.getCamera().real_rotation_target+(delta*5), true)

    if Input.is_action_just_pressed("ui_accept"):
        self.loadGame()

    if Input.is_action_just_pressed("ui_select"):
        self.newGame()

func newGame():
    global.cameraRotation = 0
    global.hasLoadedGame = true
    global.memory = {}
    transition.long_fade_to("res://levels/IntroScene.tscn")

func loadGame():
    if not global.hasLoadedGame:
        global.loadGame()
        global.hasLoadedGame = true
        if global.memory.has("roomPath"):
            # global transition scene, see res://scripts/transition.gd
            transition.long_fade_to(global.memory["roomPath"])
            if global.memory.has("active_save_point"):
                global.isRespawning = true
        elif not global.memory.has("game_story_has_started"):
            transition.long_fade_to("res://levels/IntroScene.tscn")