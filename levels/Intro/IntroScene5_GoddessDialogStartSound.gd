extends "res://scripts/AbortSound.gd"

# @override
func activateScript():
    var goddess = get_node("../../..")
    var player = goddess.get_node("../Player")
    player.getCamera().rotateTo(0, false)
    global.memory["intro_scene_goddess"] = true