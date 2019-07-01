extends "res://scripts/NPC.gd"

onready var player = get_tree().get_root().get_node("level/Player")
var turnedOffLights = false

func _ready():
    set_process(true)
    set_physics_process(true)

    set_collision_mask_bit(1, true)

func _process(delta):
    if not turnedOffLights:
        player.lightsOff()
        turnedOffLights = true