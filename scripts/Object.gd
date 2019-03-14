extends KinematicBody

onready var textBox = get_node("Object TextBox").get_node("TextBox")

func _ready():
    set_process_input(true)

func _input(event):
    if textBox.visible \
    and event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.pressed:
        activate()


func isActive():
    return visible

func passiveActivate():
    if global.activeInteractor == null:
        global.activeInteractor = textBox
        textBox.interact()
    else:
        global.activeInteractor.interact()