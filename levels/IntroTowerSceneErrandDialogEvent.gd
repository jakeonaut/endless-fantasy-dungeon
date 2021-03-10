extends "res://scripts/_InteractionAreaEvent_template.gd"

var tootioleInstanceName = "yellow"
var tootioleErrandDialogName = "TextBox5"
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