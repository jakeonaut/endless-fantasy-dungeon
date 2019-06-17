extends Area

onready var parent = get_parent()

var touchingPlayer = false
var wasTouchingPlayer = false
var is_touching_speed_boost = false
var speed_boost_angle = 0
var speed_boost_origin = Vector3(0,0,0)

func _ready():
    set_process(true)
    
func isActive():
    return parent.has_method("isActive") and parent.isActive()

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

    if global.pauseGame and not global.pauseMoveInput: return

    is_touching_speed_boost = false
    var areas = get_overlapping_areas()
    for area in areas:
        if area.is_in_group("speedboosts"):
            is_touching_speed_boost = true
            speed_boost_angle = area.get_node("..").rotation.y