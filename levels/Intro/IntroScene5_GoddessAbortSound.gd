extends "res://scripts/AbortSound.gd"

# @override
func activateScript():
    var goddess = get_node("../../..")
    goddess.visible = false
    var collisionShape = goddess.get_node("CollisionShape")
    collisionShape.disabled = true
    global.memory["intro_scene_5_goddess"] = true