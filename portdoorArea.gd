extends Area

onready var playerArea = get_tree().get_root().get_node("level/Player/InteractionArea")
export var connectedScene = "GenericScene.tscn"

func _ready():
	set_process(true)
	
func _process(delta):
	if touchingPlayer():
		global.lastDoor = get_parent().name
		get_tree().change_scene("res://" + connectedScene)
		
func touchingPlayer():
	var areas = get_overlapping_areas()
	for area in areas:
		if area == playerArea:
			return true
	return false