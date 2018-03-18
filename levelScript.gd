extends Node

func _ready():
	if global.lastDoor != "":
		var door = get_node(global.lastDoor)
		if door != null:
			door.land()
		global.lastDoor = ""
