extends "GameMover.gd"

onready var pickupSound = get_node("Sounds/PickupSound")
onready var throwSound = get_node("Sounds/ThrowSound")
onready var player = get_parent().get_node("Player")

var is_held = false
var was_just_thrown = false

var pickupCounter = 0
var pickupCounterMax = 10

var throw_speed = 14
var jump_force = 10

func _ready():
    set_process(true)
    set_physics_process(true)

func _process(delta):
    #._process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    if global.activeThrowableObject == self and pickupCounter < pickupCounterMax:
        pickupCounter += 1

func _physics_process(delta):
    #._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

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
        hv = player.facing.normalized() * throw_speed
        vv = jump_force
    elif on_ground: 
        hv = Vector3()

# @override
func landed():
    .landed() #super
    set_collision_mask_bit(1, true)

func isActive():
    # since "isActive" is used for determining when the object is "interacted" with
    # by the player, don't count as "active" when player is holding this object.
    # BECAUSE player will already know about it through the global var.
    return visible and !global.activeThrowableObject

func activate():
    # Should be able to talk while holding an object.
    if global.activeThrowableObject == null:
        # Pick up
        pickupSound.play()
        is_held = true

        global.activeThrowableObject = self
        pickupCounter = 0
    elif pickupCounter >= pickupCounterMax and global.activeThrowableObject == self:
        # Throw!
        throwSound.play()
        is_held = false
        was_just_thrown = true

        global.activeThrowableObject = null
