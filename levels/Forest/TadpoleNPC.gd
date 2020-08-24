extends "res://scripts/GameMover.gd"

onready var textBox = get_node("NPC TextBox").get_node("TextBox")
onready var youSavedMyBabiesTextBox = get_node("SavedTextContainer").get_node("TextBox")
onready var interactionArea = get_node("SmallInteractionArea")
onready var frogDetectionArea = get_node("FrogDetectionArea")

var youSavedMyBabies = false

func _ready():
    set_process(true)
    set_physics_process(true)

    set_collision_mask_bit(1, false)

func isActive():
    return visible

func activate():
    if global.activeInteractor == null:
        if not youSavedMyBabies:
            global.activeInteractor = textBox
            textBox.interact()
        elif youSavedMyBabies:
            global.activeInteractor = youSavedMyBabiesTextBox
            youSavedMyBabiesTextBox.interact()

func passiveActivate(delta):
    pass

func stopPassiveActivate():
    pass

func _process(delta):
    if not youSavedMyBabies:
        var areas = frogDetectionArea.get_overlapping_areas()
        var glitchedFrogs = 0
        for area in areas:
            if area.is_in_group("enemies"):
                if area.get_node("..").isActive():
                    glitchedFrogs += 1
        if glitchedFrogs == 0:
            youSavedMyBabies = true

func _physics_process(delta):
    #._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    is_touching_water = interactionArea.is_touching_water
    .processPhysics(delta)