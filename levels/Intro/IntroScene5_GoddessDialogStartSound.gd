extends "res://scripts/AbortSound.gd"

# @override
func activateScript():
    var goddess = get_node("../../..")
    var player = goddess.get_node("../Player")
    player.getCamera().rotateTo(177, false)
    global.memory["intro_scene_5_goddess"] = true