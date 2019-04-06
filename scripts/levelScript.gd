extends Node

func _ready():
    global.activeInteractor = null
    if global.lastDoor != "":
        var door = get_node(global.lastDoor)
        if door != null:
            door.land()   
        else:
            # if no door found, pick the first door in the level!
            var children = get_children()
            for child in children:
                if child.is_in_group("doors"):
                    child.land()
                    break
        global.lastDoor = ""
        
    if global.cameraRotation != null:
        get_node("Player").getCamera().setRotationMat(global.cameraRotation)
        global.cameraRotation = null

    # doing some MEMORY management
    if global.memory.has("active_save_point"):
        global.activeSavePoint = global.memory["active_save_point"]