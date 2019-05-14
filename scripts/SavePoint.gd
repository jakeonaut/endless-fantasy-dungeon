extends Spatial

onready var saveSound = get_node("SaveSound")

var MIN_STEP = 1
var MAX_STEP = -4
var step = MIN_STEP
var id = null

func _ready():
    set_process(true)
    id = generateId()

func _process(delta):
    if global.memory.has("active_save_point") and global.memory["active_save_point"] == self.id:
        step = MAX_STEP
    else:
        step = MIN_STEP
    rotate_y(step*delta)

func generateId():
    return get_tree().get_root().get_node("level").get_filename() + ":" + get_name()

func passiveActivate():
    if not global.memory.has("active_save_point") or global.memory["active_save_point"] != self.id:
        saveSound.play()
        global.memory["active_save_point"] = self.id
        global.memory["active_save_point_x"] = self.translation.x
        global.memory["active_save_point_y"] = self.translation.y
        global.memory["active_save_point_z"] = self.translation.z
        global.memory["roomPath"] = get_tree().get_root().get_node("level").get_filename()
        global.saveGame()

func isActive():
    return true