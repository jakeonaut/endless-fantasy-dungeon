extends Node

onready var player = get_node("Player")

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

    if global.playerJustFell and global.lastOnGroundPoint != null and global.cameraRotation != null:
        player.translation = global.lastOnGroundPoint
        player.getCamera().rotateTo(global.cameraRotation, true)

        global.playerJustFell = false
        global.lastOnGroundPoint = null
        global.cameraRotation = null

    # update music
    musicPlayer.conductFromScenePath(self.filename)

    # doing some MEMORY management
    if global.memory.has("active_save_point"):
        global.activeSavePoint = global.memory["active_save_point"]
    if global.memory.has("player_costume"):
        player.wearCostume(global.memory["player_costume"])