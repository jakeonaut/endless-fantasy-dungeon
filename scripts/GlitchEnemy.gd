extends Spatial

onready var meshInstance = get_node("MeshInstance")
var flipTimer = 0
var flipTimeLimit = 4

# Called when the node enters the scene tree for the first time.
func _ready():
    set_process(true)

func _process(delta):
    flipTimer += delta*5
    if flipTimer >= flipTimeLimit:
        flipTimer = 0
        meshInstance.get_mesh().set_flip_faces(not meshInstance.get_mesh().get_flip_faces())
        meshInstance.rotate_x(PI/2)

func isActive():
    return true

func activate():
    pass

func passiveActivate(delta):
    pass

func stopPassiveActivate():
    pass