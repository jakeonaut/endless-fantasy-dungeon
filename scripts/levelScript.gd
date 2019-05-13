extends Node

onready var player = get_node("Player")

func _ready():
    if not global.hasLoadedGame:
        global.loadGame()
        global.hasLoadedGame = true
        if global.memory.has("roomPath"):
            transition.path = global.memory["roomPath"]
            transition.change_scene()
            return
        

    global.activeInteractor = null
    global.activeThrowableObject = null
    global.pauseMoveInput = false

    # doing some MEMORY management
    if global.memory.has("active_save_point"):
        global.activeSavePoint = global.memory["active_save_point"]
    if global.memory.has("player_costume"):
        player.wearCostume(global.memory["player_costume"])

    if global.playerJustFell:
        if global.cameraRotation:
            player.getCamera().rotateTo(global.cameraRotation, true)
        global.playerJustFell = false   
    
    if global.memory.has("lastDoor"):
        var door = get_node(global.memory["lastDoor"])
        if door != null:
            door.land()   
        else:
            # if no door found, pick the first door in the level!
            var children = get_children()
            for child in children:
                if child.is_in_group("doors"):
                    child.land()
                    break

    # update music
    musicPlayer.conductFromScenePath(self.filename)

    global.saveGame()        