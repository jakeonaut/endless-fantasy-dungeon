extends Node

onready var saveSound = get_node("SaveSound")

var MIN_STEP = 1
var MAX_STEP = -4
var step = MIN_STEP

func _ready():
    set_process(true)

func _process(delta):
    if global.activeSavePoint == self:
        step = MAX_STEP
    else:
        step = MIN_STEP
    rotate_y(step*delta)

func isActive():
    return true

func activate():
    saveSound.play()