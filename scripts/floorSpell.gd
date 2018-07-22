extends KinematicBody


onready var transformSound = get_node("TransformSound")
onready var player = get_parent().get_node("Player")

func _ready():
	# visible = false # to hide on room load
	pass

func interact():
	if visible:
		transformSound.play()
		player.floorTransform()
		visible = false