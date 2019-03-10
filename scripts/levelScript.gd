extends Node

func _ready():
    if global.lastDoor != "":
        var door = get_node(global.lastDoor)
        if door != null:
            door.land()
        global.lastDoor = ""
    else:
        # if no door specified, pick the first door in the level!
        var children = get_children()
        for child in children:
            if child.is_in_group("doors"):
                child.land()
                break
        
    var player = get_node("Player")
    if global.cameraRotation != null:
        player.getCamera().setRotationMat(global.cameraRotation)
        global.cameraRotation = null