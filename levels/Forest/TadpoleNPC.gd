extends "res://scripts/GameMover.gd"

onready var textBox = get_node("NPC TextBox").get_node("TextBox")
onready var interactionArea = get_node("InteractionArea")

func _ready():
    set_process(true)
    set_physics_process(true)

    set_collision_mask_bit(1, true)

func isActive():
    return visible

func activate():
    if global.activeInteractor == null:
        global.activeInteractor = textBox
        textBox.interact()

func passiveActivate(delta):
    pass

func stopPassiveActivate():
    pass

func _physics_process(delta):
    #._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    is_touching_water = interactionArea.is_touching_water
    .processPhysics(delta)