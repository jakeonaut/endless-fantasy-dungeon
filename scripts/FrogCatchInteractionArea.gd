extends Area

onready var playerArea = get_parent().get_parent().get_node("Player/InteractionArea")

var interactingWithPlayer = false
var talkingWithPlayer = false

func _ready():
    set_process(true)

func _process(delta):
    if touchingPlayer():
        PassiveInteractActivate()
    elif not touchingPlayer():
        interactingWithPlayer = false

func touchingPlayer():
    var areas = get_overlapping_areas()
    for area in areas:
        if area == playerArea:
            return true
    return false


func PassiveInteractActivate():
    if not get_parent().visible: return

    # if global.activeInteractor == null:
    #	interactingWithPlayer = true
    get_parent().interact()
    if not interactingWithPlayer:
        interactingWithPlayer = true
        get_parent().playCatchSound()