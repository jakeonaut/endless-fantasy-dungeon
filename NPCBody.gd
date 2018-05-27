extends KinematicBody

onready var textBox = get_node("NPC TextBox").get_node("TextBox")


func isActive():
	return textBox.visible

func interact():
	if global.activeInteractor == null:
		global.activeInteractor = textBox
		textBox.interact()
	else:
		global.activeInteractor.interact()