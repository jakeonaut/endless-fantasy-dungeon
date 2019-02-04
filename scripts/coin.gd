extends Node

onready var coinSound = get_node("coinSound")

var MIN_STEP = -2
var MAX_STEP = -12
var step = MIN_STEP

var disappearing = false
var disappearTimer = 30

func _ready():
    set_process(true)

func _process(delta):
    if disappearing and is_visible():
        step = MAX_STEP
        translate(Vector3(0, -MIN_STEP*delta, 0))
        disappearTimer -= 1
        if disappearTimer <= 0: hide()
    else:
        step = MIN_STEP
    rotate_y(step*delta)

func isActive():
    return is_visible() and not disappearing

func activate():
    coinSound.play()
    disappearing = true