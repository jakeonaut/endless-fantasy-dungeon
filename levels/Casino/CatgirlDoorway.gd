extends "res://scripts/NPC.gd"

var walkOutOfDoorway = 0
var walkTimer = 0
var walkTimeLimit = 20

func _ready():
    set_process(true)
    set_physics_process(true)
    walk_speed = 4
    set_collision_mask_bit(1, true)

func _process(delta):
    #._process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500
    pass

func _physics_process(delta):
    #._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500
    pass

func processInputs(delta):
    if walkOutOfDoorway == 1:
        set_collision_mask_bit(1, false)
        walkOutOfDoorway = 2
    # fall through intentionally, this script happens on the processPhysics() loop
    if walkOutOfDoorway == 2 or walkOutOfDoorway == 3:
        if walkOutOfDoorway == 2:
            hv = Vector3(0, 0, 1) * walk_speed
        if walkOutOfDoorway == 3:
            hv = Vector3(1, 0, 0) * walk_speed

        walkTimer += (delta*22)
        if walkTimer >= walkTimeLimit:
            walkTimer = 0
            walkOutOfDoorway += 1
            if walkOutOfDoorway >= 4:
                set_collision_mask_bit(1, true)
    else:
        hv = Vector3(0,0,0)
