extends Node

func _ready():
	if global.lastDoor != "":
		var door = get_node(global.lastDoor)
		if door != null:
			door.land()
		global.lastDoor = ""
		
	if global.cameraRotation != null:
		var player = get_node("Player")
		player.get_node("TheCamera").rotation_degrees = global.cameraRotation
		global.cameraRotation = null