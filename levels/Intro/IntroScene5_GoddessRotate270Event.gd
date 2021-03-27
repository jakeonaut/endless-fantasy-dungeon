extends "res://scripts/_InteractionAreaEvent_template.gd"

var hasActivated = false

func isActive():
    return !hasActivated && .isActive()

func activate():
    .activate()

func passiveActivate(delta):
    .passiveActivate(delta)
    var player = get_tree().get_root().get_node("level").get_node("Player")
    player.getCamera().rotateTo(270, false)
    hasActivated = true

func stopPassiveActivate():
    .stopPassiveActivate()