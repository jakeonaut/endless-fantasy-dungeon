extends Spatial

onready var meshInstance = get_node("MeshInstance")
var flipTimer = 0
var flipTimeLimit = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    set_process(true)

func _process(delta):
    flipTimer += delta*10
    if flipTimer >= flipTimeLimit:
        flipTimer = 0
        flipTimeLimit = randf()*3+0.5
        meshInstance.get_mesh().set_flip_faces(not meshInstance.get_mesh().get_flip_faces())
        meshInstance.rotate_x(PI/2)

        meshInstance.translation.x = randi()%2-1 
        meshInstance.translation.y = randi()%1+0
        meshInstance.translation.z = randi()%2-1

func isActive():
    return true

func activate():
    pass

func passiveActivate():
    pass

func stopPassiveActivate():
    pass