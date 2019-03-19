extends Area

var touchingPlayer = false
var wasTouchingPlayer = false
onready var parent = get_parent()

func _ready():
    set_process(true)

func isActive():
    return parent.has_method("isActive") and \
           parent.isActive()

func PassiveInteractActivate():
    if parent.has_method("passiveActivate"):
        parent.passiveActivate()
    touchingPlayer = true

func _process(delta):
    if not touchingPlayer and not wasTouchingPlayer:
        if parent.has_method("stopPassiveActivate"):
            parent.stopPassiveActivate()
        
    # need to have this buffer variable because the PlayerInteractionArea
    # handles the PassiveInteractActivate method, and this can occur
    # before or after this NPC's _process event
    wasTouchingPlayer = touchingPlayer
    touchingPlayer = false