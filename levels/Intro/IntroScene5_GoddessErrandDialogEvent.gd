extends "res://scripts/_InteractionAreaEvent_template.gd"

# TODO(jaketrower): Just genericize and export var
var tootioleInstanceName = "NPC3"
var tootioleErrandDialogName = "NPC TextBox"
var hasActivated = false

func isActive():
    return !hasActivated && .isActive()

func activate():
    .activate()

func passiveActivate(delta):
    .passiveActivate(delta)
    var tootoriole = get_tree().get_root().get_node("level").get_node(tootioleInstanceName)
    var errandDialog = tootoriole.get_node(tootioleErrandDialogName)
    global.activeInteractor = errandDialog
    errandDialog.interact()
    hasActivated = true

func stopPassiveActivate():
    .stopPassiveActivate()