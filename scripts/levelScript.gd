extends Node

onready var player = get_node("Player")

func _ready():
    global.activeInteractor = null
    global.activeThrowableObject = null
    global.pauseMoveInput = false
    global.pauseGame = false

    player.lightsOn()

    if global.memory.has("player_costume"):
        player.wearCostume(global.memory["player_costume"])
    
    if global.memory.has("active_save_point") and global.isRespawning \
       and global.memory["roomPath"] == self.get_filename():
        player.global_transform.origin = Vector3(
            global.memory["active_save_point_x"], 
            global.memory["active_save_point_y"], 
            global.memory["active_save_point_z"])
        if global.cameraRotation:
            player.getCamera().rotateTo(global.cameraRotation, true)
    elif global.memory.has("lastDoor"):
        var door_id = global.memory["lastDoor"]
        var doors = get_tree().get_nodes_in_group("doors")
        var found_door = null
        for door in doors:
            if door.id == door_id:
                found_door = door
                break
        # if no door found, pick the first door in the level!
        if not found_door and doors.size() > 0:
            found_door = doors[0]

        if found_door: found_door.land(global.cameraRotation)

    # update music
    musicPlayer.conductFromScenePath(self.filename)

    global.isRespawning = false