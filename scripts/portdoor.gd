extends Sprite3D

export var connectedScene = "GenericScene.tscn"
export var isLocked = false

onready var area = get_node("Area")
onready var enterSound = get_node("EnterSound")
onready var player = get_tree().get_root().get_node("level/Player")
onready var landingPad = get_node("landing-pad")
onready var textBox = get_node("portdoorTextBox").get_node("TextBox")

func _ready():
	area.hide()
	landingPad.hide()
	
	area.connectedScene = connectedScene
	
func land():
	enterSound.play()
	player.global_transform.origin = landingPad.global_transform.origin

func isActive():
	return textBox.visible

func interact():
	if global.activeInteractor == null:
		global.activeInteractor = textBox
		textBox.interact()
	else:
		global.activeInteractor.interact()