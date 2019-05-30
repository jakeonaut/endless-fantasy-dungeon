extends Spatial

onready var coinSound = get_node("coinSound")

var MIN_STEP = -2
var MAX_STEP = -12
var step = MIN_STEP

var disappearing = false
var disappearTimer = 12

func _ready():
    set_process(true)

func _process(delta):
    if is_visible():
        if disappearing:
            step = MAX_STEP
            translate(Vector3(0, -MIN_STEP*delta, 0))
            if disappearing: 
                disappearTimer -= (delta*22)
                if disappearTimer <= 0: 
                    hide()
                    disappearing = false
        else:
            step = MIN_STEP
        rotate_y(step*delta) 

func isActive():
    return is_visible() and not disappearing

func passiveActivate():
    coinSound.play()
    disappearing = true

    global.numCoins += 1