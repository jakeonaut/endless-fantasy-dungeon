extends "res://scripts/AbortSound.gd"

# @override
func activateScript():
    var player = get_tree().get_root().get_node("level/Player")
    player.getCamera().forceRotation(360, 0)