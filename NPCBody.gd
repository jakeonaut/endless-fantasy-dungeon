extends KinematicBody

onready var dialogSound = get_node("DialogSound")
onready var textBox = get_node("NPC TextBox")

func _ready():
	set_process_input(true)
	textBox.hide()

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		textBox.show()
		dialogSound.play()