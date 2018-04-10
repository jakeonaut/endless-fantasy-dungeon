extends KinematicBody

onready var textBox = get_node("NPC TextBox")

func _ready():
	set_process_input(true)

func _input(event):
	if isActive() \
	and event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		interact()


func isActive():
	return textBox.visible

func interact():
	textBox.interact()