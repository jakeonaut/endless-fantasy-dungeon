extends Area

onready var playerArea = get_tree().get_root().get_node("level").get_node("Player/InteractionArea")


func _ready():
    set_process(true)

func _process(delta):
    if touchingPlayer():
        PassiveInteractActivate()

func touchingPlayer():
    var areas = get_overlapping_areas()
    for area in areas:
        if area == playerArea:
            return true
    return false

func PassiveInteractActivate():
    var parent = get_parent()
    if not parent.isActive(): return

    parent.activate()