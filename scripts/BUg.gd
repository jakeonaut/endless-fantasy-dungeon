extends KinematicBody

onready var textBox = get_node("Object TextBox").get_node("TextBox")
onready var transformSound = get_node("TransformSound")
onready var player = get_parent().get_node("Player")

func _ready():
	pass

func interact():
	if visible:
		transformSound.play()
		player.bugTransform()
		visible = false