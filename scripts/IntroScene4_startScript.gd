extends Node

func _ready():
    if global.lastDoor != "":
        var door = get_node(global.lastDoor)
        if door != null:
            door.land()
        global.lastDoor = ""
        
    var player = get_node("Player")
    if global.cameraRotation != null:
        player.getCamera().setRotationMat(global.cameraRotation)
        global.cameraRotation = null
    
        
    player.getCamera().rotateTo(0)