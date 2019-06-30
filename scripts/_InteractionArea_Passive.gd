extends Area

var touchingPlayer = false
var wasTouchingPlayer = false
var is_touching_water = false
onready var parent = get_parent()

func _ready():
    set_process(true)

func isActive():
    return parent.has_method("isActive") and \
           parent.isActive()

func PassiveInteractActivate(delta):
    if parent.has_method("passiveActivate"):
        parent.passiveActivate(delta)
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

    var areas = get_overlapping_areas()
    is_touching_water = false
    for area in areas:
        if area.is_in_group("water"):
            is_touching_water = true