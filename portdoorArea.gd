extends Area

onready var playerArea = get_tree().get_root().get_node("level/Player/InteractionArea")
export var connectedScene = "GenericScene.tscn"
var transitioning = false

func _ready():
	set_process(true)
	
func _process(delta):
	if touchingPlayer():
		global.lastDoor = get_parent().name
		if not transitioning:
			# global transition scene
			transition.fade_to("res://" + connectedScene)
			transitioning = true
		
func touchingPlayer():
	var areas = get_overlapping_areas()
	for area in areas:
		if area == playerArea:
			return true
	return false