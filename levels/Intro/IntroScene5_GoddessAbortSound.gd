extends "res://scripts/AbortSound.gd"

# @override
func activateScript():
    # TODO(jaketrower): relative paths can be dangerous to move around
    var goddess = get_node("../../..")
    goddess.visible = false
    var collisionShape = goddess.get_node("CollisionShape")
    collisionShape.disabled = true
    global.memory["intro_scene_goddess"] = true
    # TODO(jaketrower): relative paths can be dangerous to move around
    var portalTownDungeon = get_node("../../../../portalTownDungeon")
    portalTownDungeon.unlock()
    musicPlayer.stopAll()