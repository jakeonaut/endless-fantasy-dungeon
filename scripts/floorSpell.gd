extends KinematicBody

onready var transformSound = get_node("TransformSound")
onready var player = get_parent().get_node("Player")
onready var levelTiles = get_parent().get_node("Level Tiles")

func _ready():
    # visible = false # to hide on room load
    pass

func interact():
    if visible:
        transformSound.play()
        player.floorTransform()
        print(global.blueTheme)
        levelTiles.theme = global.blueTheme
        visible = false