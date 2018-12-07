extends KinematicBody

onready var textBox = get_node("Frog TextBox").get_node("TextBox")
onready var catchSound = get_node("CatchSound")

func _ready():
    set_process_input(true)
    randomize()

func is_activeTextboxMyChild():
    var node = global.activeInteractor
    while node and node.get_node("..") != get_tree():
        if node == self:
            return true
        node = node.get_node("..")
    return false

func isActive():
    return textBox.visible

func interact():
    translation.x = rand_range(7.0, -7.0)
    translation.y = rand_range(2.5, 7.0)
    translation.z = rand_range(3.0, -11.0)
    
func playCatchSound():
    catchSound.play()

func interactTalk():
    if global.activeInteractor == null:
        global.activeInteractor = textBox
        textBox.interact()
    else:
        global.activeInteractor.interact()
