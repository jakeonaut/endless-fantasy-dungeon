extends "res://scripts/GameMover.gd"

onready var pickupSound = get_node("Sounds/PickupSound")
onready var throwSound = get_node("Sounds/ThrowSound")
onready var shatterSound = get_node("Sounds/ShatterSound")
onready var levelRoot = get_tree().get_root().get_node("level")
var player = null

# TODO(jaketrower): doing stuff like this... is dangerous 
const coin_resource = preload("res://levels/Casino/coin.tscn")

var is_held = false
var was_just_thrown = false
var has_initially_landed = false

var pickupCounter = 0
var pickupCounterMax = 3

var throw_speed = 14
var jump_force = 10

func _ready():
    set_physics_process(true)
    player = levelRoot.get_node("Player")

func _process(delta):
    #._process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    if is_held and pickupCounter < pickupCounterMax:
        pickupCounter += (delta*22)

func _physics_process(delta):
    #._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500
    
    if global.pauseGame: return

    if is_held:
        self.translation = player.translation
        self.translation.y += 2 # nodelta
        set_collision_mask_bit(1, false)
        return

    .processPhysics(delta) # super
    if not has_initially_landed and on_ground:
        has_initially_landed = true

# @override
func processInputs(delta):
    if take_fall_damage:
        vv = jump_force
        on_ground = false

    if was_just_thrown:
        was_just_thrown = false
        hv = player.facing.normalized() * throw_speed
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
        newCoin.passiveActivate(0)
        
        hide()
        set_collision_mask_bit(1, false)

func isActive():
    return visible

func activate():
    if not is_held:
        pickupSound.play()
        is_held = true
        pickupCounter = 0
    elif pickupCounter >= pickupCounterMax and is_held:
        throwSound.play()
        is_held = false
        was_just_thrown = true
