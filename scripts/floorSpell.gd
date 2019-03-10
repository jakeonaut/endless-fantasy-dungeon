extends KinematicBody

onready var transformSound = get_node("TransformSound")
onready var player = get_tree().get_root().get_node("level/Player")
onready var levelTiles = get_tree().get_root().get_node("level/Level Tiles")

func _ready():
    pass

func isActive():
    return visible

func activate():
    transformSound.play()
    player.floorTransform()
    print(global.blueTheme)
    levelTiles.theme = global.blueTheme
    visible = false