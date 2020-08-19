extends Spatial

onready var player = get_tree().get_root().get_node("level/Player")
onready var playerSprite = get_tree().get_root().get_node("level/Player/Sprite3D")
onready var cubeContainer = get_node("CubeContainer")
onready var cubeSound = get_node("cubeSound")
onready var cubeSound2 = get_node("cubeSound2")
onready var cubeSound3 = get_node("cubeSound3")
onready var textBox = get_node("TextContainer/TextBox")

var MIN_STEP = -2
var MID_STEP = 5
var MAX_STEP = -12
var step = MIN_STEP

var disappearing = false
var disappearing2 = false
var disappearing3 = false
var disappearTimer = 0
var disappearTimeLimit = 12
var disappearBigTimeLimit = 44

func _ready():
    set_process(true)
    set_physics_process(true)

func _physics_process(delta):
    if disappearing or disappearing2:
        player.faceDown()
        player.translate(Vector3(0, 2*delta, 0))
        player.dir = Vector3(0.0, 0.0, 0.0)
        player.can_broom = false

    if disappearing or disappearing2 or disappearing3 or global.activeInteractor == textBox:
        # rotate camera slowly
        player.getCamera().rotateTo(player.getCamera().real_rotation_target+(delta*64), true)

func _process(delta):
    if is_visible():
        if disappearing:
            step = MAX_STEP
            translate(Vector3(0, 1*delta, 0))
            disappearTimer += (delta*22)
            if disappearTimer >= disappearTimeLimit:
                disappearTimer = 0
                disappearing = false
                disappearing2 = true
        elif disappearing2:
            step = MID_STEP
            translate(Vector3(0, 0.5*delta, 0))
            disappearTimer += (delta*22)
            cubeContainer.rotate_y(disappearTimer*delta)
            cubeContainer.rotate_x((disappearTimer/2)*delta)
            if disappearTimer >= disappearBigTimeLimit:
                disappearing2 = false
                disappearing3 = true
                disappearTimer = 0
        elif disappearing3:
            disappearTimer += (delta*33)

            var lerp_timer = (disappearTimer / disappearTimeLimit)
            var source_transform = self.global_transform
            var target_transform = player.global_transform
            self.global_transform = source_transform.interpolate_with(target_transform, lerp_timer)

            if disappearTimer >= disappearTimeLimit:
                disappearing3 = false
                hide()
                global.pauseMoveInput = false
                global.pauseGame = false
                cubeSound3.play()
                global.activeInteractor = textBox
                textBox.interact()
                # update music
                musicPlayer.conductFromScenePath(get_tree().get_root().get_node("level").filename)
        else:
            step = MIN_STEP
        cubeContainer.rotate_y(step*delta)
        cubeContainer.rotate_x((step/2)*delta)

func isActive():
    return is_visible() and not disappearing and not disappearing2 and not disappearing3

func passiveActivate(delta):
    musicPlayer.stopAll()
    cubeSound.play()
    cubeSound2.play()

    disappearing = true

    global.pauseGame = true
    global.pauseMoveInput = true
    player.global_transform.origin = self.global_transform.origin