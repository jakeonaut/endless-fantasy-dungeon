extends KinematicBody

onready var textBox = get_node("NPC TextBox").get_node("TextBox")

func isActive():
    return visible

func activate():
    if global.activeInteractor == null:
        global.activeInteractor = textBox
        textBox.interact()

func passiveActivate():
    pass

func stopPassiveActivate():
    pass