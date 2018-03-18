extends Sprite3D

onready var area = get_node("Area")
export var connectedScene = "GenericScene.tscn"
onready var enterSound = get_node("EnterSound")
onready var player = get_tree().get_root().get_node("level/Player")

func _ready():
	hide()
	area.connectedScene = connectedScene
	
func land():
	enterSound.play()
	var landingPad = get_node("landing-pad")
	player.global_transform.origin = landingPad.global_transform.origin