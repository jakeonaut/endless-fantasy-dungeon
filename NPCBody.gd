extends KinematicBody

onready var sprite = get_node("Sprite3D")
onready var dialogSound = get_node("DialogSound")
onready var textBox = get_node("NPC TextBox")

export var spriteTexture = preload("res://assets/Imag20000.png")
export var portraitTexture = preload("res://assets/mini.png")
export var bbcodeText = "edit me"

func _ready():
	sprite.texture = spriteTexture
	textBox.portraitTexture = portraitTexture
	textBox.bbcodeText = bbcodeText
	textBox.hide()
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
	if (!textBox.visible):
		showTextBox()
	else:
		hideTextBox()

func showTextBox():
	textBox.show()
	dialogSound.play()
	
func hideTextBox():
	textBox.hide()
	dialogSound.play()