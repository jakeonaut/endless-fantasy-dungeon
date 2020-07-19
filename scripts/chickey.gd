extends "res://scripts/GameMover.gd"

onready var squawkSound = get_node("Sounds/BarkSound")
onready var sprite = get_node("Sprite3D")
onready var player = get_tree().get_root().get_node("level/Player")
onready var passiveInteractionArea = get_node("PassiveInteractionArea")

# TODO(jaketrower): doing stuff like this... is dangerous 
# see: https://www.reddit.com/r/godot/comments/ait6y8/preloading_in_godot_31_vs_30/
const egg_resource = preload("res://sceneObjects/NPCSeed.tscn")

var spawn_origin

var jump_force = 10
var shouldJump = false
var random_facing = Vector3(0, 0, -1) #default to facing forward
var facing_timer = 0
var facing_time_limit = 4

var pickupCounter = 0
var pickupCounterMax = 3
var is_held = false
var was_just_thrown = false
var thrown_down = false
var has_initially_landed = false
var can_move_again = true
var throw_speed = 14

func _ready():
    set_process_input(true)
    set_physics_process(true)

    spawn_origin = self.global_transform.origin
    walk_speed = 4

func _process(delta):
    #._process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    facing_timer += (delta*22)
    if facing_timer > facing_time_limit:
        random_facing = Vector3(randi()%3-1, 0, randi()%3-1)
        facing_timer = 0

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

    if not on_ground and translation.y < -12:
        respawn()

func respawn():
    self.hv = Vector3(0, 0, 0)
    self.linear_velocity = Vector3(0, 0, 0)

    self.global_transform.origin = spawn_origin
    self.global_transform.origin.y += 2

    self.random_facing = Vector3(0, 0, 0)
    self.facing_timer = 0

    self.is_held = false
    self.was_just_thrown = false
    self.thrown_down = false
    self.has_initially_landed = false
    self.can_move_again = true
    
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
    thrown_down = false

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
    set_collision_mask_bit(1, true)
    if not has_initially_landed:
        has_initially_landed = true
    can_move_again = true
    self.random_facing = Vector3(0, 0, 0)
    self.facing_timer = 0
    
func isActive():
    return visible

func activate():
    if not is_held:
        player.is_holding_chicken = true
        squawkSound.play()
        is_held = true
        pickupCounter = 0
        can_move_again = false
    elif pickupCounter >= pickupCounterMax and is_held:
        player.is_holding_chicken = false # will only properly work once we put a limit on pick ups...
        squawkSound.play()
        is_held = false
        was_just_thrown = true
        if Input.is_action_pressed("ui_jump") and not player.is_pressing_horizontal_input:
            thrown_down = true
