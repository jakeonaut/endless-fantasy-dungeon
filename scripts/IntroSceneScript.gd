extends Node

func _ready():
    if global.lastDoor != "":
        var door = get_node(global.lastDoor)
        if door != null:
            door.land()
        global.lastDoor = ""
        
    if global.cameraRotation != null:
        var player = get_node("Player")
        player.get_node("CameraY").setRotationMat(global.cameraRotation)
        global.cameraRotation = null
        
    # TODO(jakeonaut): Global variable for is_game_started??
    var npc = get_node("yellow")
    npc.get_node("InteractionArea").InteractActivate()