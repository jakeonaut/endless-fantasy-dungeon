extends "GameMover.gd"

onready var pickupSound = get_node("Sounds/PickupSound")
onready var throwSound = get_node("Sounds/ThrowSound")
onready var player = get_parent().get_node("Player")

var is_held = false
var was_just_thrown = false

var throw_speed = 14
var jump_force = 10

func _ready():
    set_physics_process(true)

func _physics_process(delta):
    if is_held:
        self.translation = player.translation
        self.translation.y += 2
        set_collision_mask_bit(1, false)
        return

    .processPhysics(delta)

# @override
func processInputs():
    if take_fall_damage:
        vv = jump_force
        on_ground = false

    if was_just_thrown:
        was_just_thrown = false
        hv = player.dir.normalized() * throw_speed
        vv = jump_force
    elif on_ground: 
        hv = Vector3()

# @override
func landed():
    .landed()
    set_collision_mask_bit(1, true)

func isActive():
    return visible

func interact():
    if not is_held:
        pickupSound.play()
        is_held = true
    else:
        throwSound.play()
        is_held = false
        was_just_thrown = true
