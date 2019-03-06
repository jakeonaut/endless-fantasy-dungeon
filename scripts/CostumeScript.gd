extends KinematicBody

onready var textBox = get_node("Object TextBox").get_node("TextBox")
onready var player = get_parent().get_node("Player")

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
    if global.activeInteractor == null:
        global.activeInteractor = textBox
        textBox.interact()
    else:
        global.activeInteractor.interact()
        visible = false
        
func GetCostume():
    if visible:
        player.wearOveralls()