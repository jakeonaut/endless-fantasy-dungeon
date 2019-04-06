extends Node

onready var saveSound = get_node("SaveSound")

var MIN_STEP = 1
var MAX_STEP = -4
var step = MIN_STEP
var id = null

func _ready():
    set_process(true)
    id = generateId()

func _process(delta):
    if global.activeSavePoint == self.id:
        step = MAX_STEP
    else:
        step = MIN_STEP
    rotate_y(step*delta)

func generateId():
    return get_tree().get_root().get_node("level").get_name() + ":" + get_name()

func passiveActivate():
    if global.activeSavePoint != self.id:
        global.activeSavePoint = self.id
        saveSound.play()
        global.memory["active_save_point"] = self.id

func isActive():
    return true