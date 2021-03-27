extends "res://scripts/AbortSound.gd"

# @override
func activateScript():
    var player = get_tree().get_root().get_node("level").get_node("Player")
    player.getCamera().rotateTo(0, false, true) #is_slow=true
    player.getCamera().rotateXTo(0, false, true) #is_slow=true
    global.memory["intro_scene_goddess"] = true