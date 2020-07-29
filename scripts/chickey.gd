extends "res://scripts/ThrowableObject.gd"

onready var sprite = get_node("Sprite3D")
onready var passiveInteractionArea = get_node("PassiveInteractionArea")

# TODO(jaketrower): doing stuff like this... is dangerous 
# see: https://www.reddit.com/r/godot/comments/ait6y8/preloading_in_godot_31_vs_30/
const egg_resource = preload("res://sceneObjects/NPCSeed.tscn")

var shouldJump = false
var random_facing = Vector3(0, 0, -1) #default to facing forward
var facing_timer = 0
var facing_time_limit = 4

var can_move_again = true

func _ready():
    set_process_input(true)
    set_physics_process(true)

    walk_speed = 4

func _process(delta):
    #._process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    facing_timer += (delta*22)
    if facing_timer > facing_time_limit:
        random_facing = Vector3(randi()%3-1, 0, randi()%3-1)
        facing_timer = 0

func _physics_process(delta):
    #._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    if not on_ground and translation.y < -12:
        respawn()

# @override
func respawn():
    .respawn()

    self.random_facing = Vector3(0, 0, 0)
    self.facing_timer = 0
    self.can_move_again = true
    
# @override
func processInputs(delta):
    .processInputs(delta)

    if can_move_again:
        if shouldJump:
            vv = jump_force
            on_ground = false
            shouldJump = false

        dir = Vector3(0.0, 0.0, 0.0)
        var curr_walk_speed = walk_speed
        if not passiveInteractionArea.is_near_doggo:
            dir += random_facing
        else:
            var my_origin = global_transform.origin
            var dog_origin = passiveInteractionArea.dog_origin
            var scared_facing = (my_origin - dog_origin).normalized()
            random_facing = scared_facing
            facing_timer = 0
            dir += scared_facing
            curr_walk_speed = walk_speed * 2
        # TODO(jaketrower): try to keep other chickeys within interaction area
        # clump together a little, but not on top of each other..
        # should have a "leader" chicken

        hv = dir * curr_walk_speed

# @override
func landed():
    .landed() # super
    can_move_again = true
    self.random_facing = Vector3(0, 0, 0)
    self.facing_timer = 0

func activate():
    # TODO(jaketrower): A little duplicatey with ThrowableObject.gd
    if not is_held and global.activeThrowableObject == null:
        player.is_holding_chicken = true
        is_floating = false
        # Pick up
        pickupSound.play()
        is_held = true
        global.activeThrowableObject = self
        pickupCounter = 0
        # self.repositionSelf()
        can_move_again = false
    elif pickupCounter >= pickupCounterMax and (global.activeThrowableObject == self or is_held):
        spawn_origin = self.global_transform.origin
        player.is_holding_chicken = false # will only properly work once we put a limit on pick ups...
        is_floating = false
        float_timer = float_time_limit
        # Throw!
        pickupSound.play() # instead of throwSOund
        is_held = false
        was_just_thrown = true
        was_planted = true
        if Input.is_action_pressed("ui_jump") and not player.is_pressing_horizontal_input:
            thrown_down = true

        global.activeThrowableObject = null
