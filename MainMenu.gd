extends Node

onready var player = get_node("Player")

func _ready():
    # ._ready() #super
    set_process(true)

    player.lightsOn()
    player.getCamera().toggleNext()
    global.pauseGame = true
    global.pauseMoveInput = true
    musicPlayer.conductFromScenePath(self.get_filename())

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
        if global.memory.has("roomPath") and global.memory["roomPath"] != self.get_filename():
            # global transition scene, see res://scripts/transition.gd
            transition.long_fade_to(global.memory["roomPath"])
            if global.memory.has("active_save_point"):
                global.isRespawning = true
        else:
            transition.long_fade_to("res://levels/IntroScene.tscn")