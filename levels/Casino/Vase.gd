extends "res://scripts/GameMover.gd"

onready var pickupSound = get_node("Sounds/PickupSound")
onready var throwSound = get_node("Sounds/ThrowSound")
onready var shatterSound = get_node("Sounds/ShatterSound")
onready var levelRoot = get_tree().get_root().get_node("level")
var player = null

const coin_resource = preload("res://sceneObjects/coin.tscn")

var is_held = false
var was_just_thrown = false
var has_initially_landed = false

var throw_speed = 14
var jump_force = 10

func _ready():
    set_physics_process(true)
    player = levelRoot.get_node("Player")

func _physics_process(delta):
    if is_held:
        self.translation = player.translation
        self.translation.y += 2
        set_collision_mask_bit(1, false)
        return

    .processPhysics(delta) # super
    if not has_initially_landed and on_ground:
        has_initially_landed = true

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
    .landed() # super
    set_collision_mask_bit(1, true)
    if not has_initially_landed:
        has_initially_landed = true
    else:
        shatterSound.play()

        var newCoin = coin_resource.instance()
        # TODO(jaketrower): This node container is an ASSUMPTION!!!
        levelRoot.get_node("coins").add_child(newCoin)
        newCoin.translation = translation
        newCoin.activate()
        
        hide()
        set_collision_mask_bit(1, false)

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
