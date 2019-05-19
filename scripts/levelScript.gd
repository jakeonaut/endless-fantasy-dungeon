extends Node

onready var player = get_node("Player")

func _ready():
    if not global.hasLoadedGame:
        global.loadGame()
        global.hasLoadedGame = true
        if global.memory.has("roomPath"):
            transition.path = global.memory["roomPath"]
            transition.change_scene()
            if global.memory.has("active_save_point"):
                global.isRespawning = true
            return
        

    global.activeInteractor = null
    global.activeThrowableObject = null
    global.pauseMoveInput = false
    global.pauseGame = false

    if global.memory.has("player_costume"):
        player.wearCostume(global.memory["player_costume"])

    
    if global.memory.has("active_save_point") and global.isRespawning and global.memory["roomPath"] == self.get_filename():
        player.global_transform.origin = Vector3(
            global.memory["active_save_point_x"], 
            global.memory["active_save_point_y"], 
            global.memory["active_save_point_z"])
        if global.cameraRotation:
            player.getCamera().rotateTo(global.cameraRotation, true)
    elif global.memory.has("lastDoor"):
        var door = get_node(global.memory["lastDoor"])
        if door != null:
            door.land(global.cameraRotation)   
        else:
            # if no door found, pick the first door in the level!
            var children = get_children()
            for child in children:
                if child.is_in_group("doors"):
                    child.land(global.cameraRotation)
                    break

    # update music
    musicPlayer.conductFromScenePath(self.filename)

    global.isRespawning = false