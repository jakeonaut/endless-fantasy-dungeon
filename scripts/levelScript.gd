extends Node

onready var player = get_node("Player")
onready var gridMap = get_node("Level Tiles")

func _ready():
    # stupid workaround https://godotengine.org/qa/23950/_ready-call-order-is-reversed-from-typical-inheritance#:~:text=When%20inheriting%2C%20typically%20the%20child,the%20parent%2C%20then%20the%20child.
    _ready_impl()

func _ready_impl():
    set_process_input(true)
    set_process(true)

    global.activeInteractor = null
    global.activeThrowableObject = null
    global.pauseMoveInput = false
    global.pauseGame = false

    player.lightsOn()

    if global.memory.has("player_costume"):
        player.wearCostume(global.memory["player_costume"])
    
    var found_door = null
    if global.memory.has("active_save_point") and global.isRespawning \
       and global.memory["roomPath"] == self.get_filename():
        player.global_transform.origin = Vector3(
            global.memory["active_save_point_x"], 
            global.memory["active_save_point_y"], 
            global.memory["active_save_point_z"])
        player.getCamera().rotation_degrees.y = global.cameraRotation
    elif global.memory.has("lastDoor"):
        var door_id = global.memory["lastDoor"]
        var doors = get_tree().get_nodes_in_group("doors")
        for door in doors:
            if door.id == door_id:
                found_door = door
                break
        # if no door found, pick the first door in the level!
        if not found_door and doors.size() > 0:
            found_door = doors[0]

    ########### (not anymore!) # camera update ... if player has never visited this room.. give it the "default" perspective
    if not global.memory.has(self.get_filename()):
        global.memory[self.get_filename()] = true
        if found_door:
            found_door.land()
            # player.getCamera().rotateTo(found_door.rotation_degrees.y + 180, true)
    elif found_door:
        found_door.land()
        # player.getCamera().rotateTo(global.cameraRotation + found_door.rotation_degrees.y + 180, true)
    # elif global.cameraRotation:
        # player.getCamera().rotateTo(global.cameraRotation, true)

    # update music
    musicPlayer.conductFromScenePath(self.get_filename())

    global.isRespawning = false

    # final global memory management
    # only treat new rooms as "save points" until we introduce save points.
    if not global.memory.has("active_save_point"):
        global.memory["roomPath"] = self.filename
        global.saveGame()


# TODO(jaketrower): Remove this level edit stuff in final cut ?!?
func _process(delta):
    if Input.is_action_just_pressed("ui_place_tile"):
        var player_position = player.global_transform.origin + (player.facing * 2)
        var grid_cell = gridMap.world_to_map(player_position)
        gridMap.set_cell_item(grid_cell.x, grid_cell.y, grid_cell.z, 0)

    if Input.is_action_just_pressed("ui_save"):
        var packed_scene = PackedScene.new()
        packed_scene.pack(get_tree().get_current_scene())
        ResourceSaver.save("res://saved_scene.tscn", packed_scene)