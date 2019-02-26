extends Area

onready var playerArea = get_parent().get_parent().get_node("Player/InteractionArea")

var interactingWithPlayer = false

func _ready():
    set_process(true)
    
func _process(delta):
    if interactingWithPlayer:
        # Conversation finished naturally
        if global.activeInteractor == null:
            interactingWithPlayer = false
        # Player walked away, or was teleported/etc.
        elif not self.touchingPlayer():
            global.activeInteractor.abort()
            interactingWithPlayer = false
        
func touchingPlayer():
    var areas = get_overlapping_areas()
    for area in areas:
        if area == playerArea:
            return true
    return false

func isActive():
    return get_parent().visible

    
func InteractActivate():
    if not isActive(): return
    
    if global.activeInteractor == null:
        interactingWithPlayer = true
    get_parent().interact()