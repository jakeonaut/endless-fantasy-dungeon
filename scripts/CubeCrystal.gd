extends Spatial

onready var player = get_tree().get_root().get_node("level/Player")
onready var playerSprite = get_tree().get_root().get_node("level/Player/Sprite3D")
onready var cubeSound = get_node("cubeSound")
onready var cubeSound2 = get_node("cubeSound2")

var MIN_STEP = -2
var MID_STEP = 5
var MAX_STEP = -12
var step = MIN_STEP

var disappearing = false
var disappearing2 = false
var disappearTimer = 0
var disappearTimeLimit = 12

func _ready():
    set_process(true)
    set_physics_process(true)

func _physics_process(delta):
    if disappearing or disappearing2:
        player.faceDown()
        if disappearTimer < 64:
            player.translate(Vector3(0, 30*delta, 0))
        player.dir = Vector3(0.0, 0.0, 0.0)
        # rotate camera slowly
        player.getCamera().rotateTo(player.getCamera().real_rotation_target+(delta*74), true)

func _process(delta):
    if is_visible():
        if disappearing:
            step = MAX_STEP
            translate(Vector3(0, -MIN_STEP*delta, 0))
            disappearTimer += (delta*22)
            if disappearTimer >= disappearTimeLimit:
                disappearTimer = 0
                disappearTimeLimit *= 8
                disappearing = false
                disappearing2 = true
        elif disappearing2:
            disappearTimer += (delta*22)
            step = MID_STEP
            rotate_y(disappearTimer*delta)
            rotate_x((disappearTimer/2)*delta)
            if disappearTimer >= disappearTimeLimit:
                hide()
                disappearing2 = false
                global.pauseMoveInput = false
                # player.getCamera().toggleNext()
        else:
            step = MIN_STEP
        rotate_y(step*delta)
        rotate_x((step/2)*delta)

func isActive():
    return is_visible() and not disappearing and not disappearing2

func passiveActivate(delta):
    musicPlayer.stop()
    cubeSound.play()
    cubeSound2.play()

    disappearing = true

    global.pauseMoveInput = true
    player.global_transform.origin = self.global_transform.origin