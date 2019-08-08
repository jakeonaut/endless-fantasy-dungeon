extends KinematicBody

onready var textBox = get_node("Frog TextBox").get_node("TextBox")
onready var catchSound = get_node("CatchSound")

func _ready():
    set_process_input(true)
    randomize()

func isActive():
    return textBox.visible

func passiveActivate(delta):
    translation.x = rand_range(5.0, -5.0)
    translation.y = rand_range(2.5, 7.0)
    translation.z = rand_range(3.0, -7.0)
    
func playCatchSound():
    catchSound.play()

func interactTalk():
    if global.activeInteractor == null:
        global.activeInteractor = textBox
        textBox.interact()
    else:
        global.activeInteractor.interact()
