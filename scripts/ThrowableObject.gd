extends "GameMover.gd"

onready var pickupSound = get_node("Sounds/PickupSound")
onready var throwSound = get_node("Sounds/ThrowSound")
onready var player = get_tree().get_root().get_node("level").get_node("Player")
onready var interactionArea = get_node("InteractionArea")

var is_held = false
var was_just_thrown = false
# so it doesn't hatch/crash on initial load
var has_initially_landed = false
var thrown_down = false
var was_planted = false

var pickupCounter = 0
var pickupCounterMax = 3

var throw_speed = 14
var jump_force = 10

func _ready():
    set_process(true)
    set_physics_process(true)

func _process(delta):
    #._process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    if (global.activeThrowableObject == self or is_held) and pickupCounter < pickupCounterMax:
        pickupCounter += (delta*22)

func _physics_process(delta):
    # ._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    if self.repositionSelf(): return

    is_touching_water = interactionArea.is_touching_water
    .processPhysics(delta)
    if not has_initially_landed and on_ground:
        has_initially_landed = true

func repositionSelf():
    if is_held:
        self.translation = player.translation
        self.translation.y += 2 # nodelta
        set_collision_mask_bit(1, false)
        return true
    return false

# @override
func processInputs(delta):
    if take_fall_damage:
        vv = jump_force
        on_ground = false

    if was_just_thrown:
        was_just_thrown = false
        hv = player.facing.normalized() * throw_speed
        vv = jump_force
        if thrown_down:
            hv = player.facing.normalized() * 0
            vv = -jump_force*2
            player.vv = jump_force*4
    elif on_ground: 
        hv = Vector3()
    thrown_down = false

# @override
func respawn():
    .respawn()

    self.is_held = false
    self.was_just_thrown = false
    self.thrown_down = false
    self.has_initially_landed = false

# @override
func landed():
    .landed() #super
    set_collision_mask_bit(1, true)
    if not has_initially_landed:
        has_initially_landed = true

func isActive():
    # since "isActive" is used for determining when the object is "interacted" with
    # by the player, don't count as "active" when player is holding this object.
    # BECAUSE player will already know about it through the global var.
    return visible and !global.activeThrowableObject

func activate():
    # Should be able to talk while holding an object.
    if not is_held and global.activeThrowableObject == null:
        is_floating = false
        # Pick up
        pickupSound.play()
        is_held = true
        global.activeThrowableObject = self
        pickupCounter = 0
        self.repositionSelf()
    elif pickupCounter >= pickupCounterMax and (global.activeThrowableObject == self or is_held):
        spawn_origin = self.global_transform.origin
        is_floating = false
        float_timer = float_time_limit
        # Throw!
        throwSound.play()
        is_held = false
        was_just_thrown = true
        was_planted = true
        # if Input.is_action_pressed("ui_jump") and not player.is_pressing_horizontal_input:
        #     thrown_down = true

        global.activeThrowableObject = null
