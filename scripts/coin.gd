extends Node

onready var coinSound = get_node("coinSound")

var MIN_STEP = -2
var MAX_STEP = -12
var step = MIN_STEP

var disappearing = false
var disappearTimer = 30

var bouncing = false
var bounceTimer = 30

func _ready():
    set_process(true)

func _process(delta):
    if is_visible():
        if disappearing or bouncing:
            step = MAX_STEP
            translate(Vector3(0, -MIN_STEP*delta, 0))
            if disappearing: 
                disappearTimer -= 1
                if disappearTimer <= 0: 
                    hide()
                    disappearing = false
            elif bouncing:
                bounceTimer -= 1
                if bounceTimer <= 0: bouncing = false
        else:
            step = MIN_STEP
        rotate_y(step*delta) 

func isActive():
    return is_visible() and not disappearing

func activate():
    coinSound.play()
    disappearing = true