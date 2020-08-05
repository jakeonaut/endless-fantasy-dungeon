extends "res://scripts/GameMover.gd"

onready var barkSound = get_node("Sounds/BarkSound")
onready var player = get_tree().get_root().get_node("level/Player")
onready var sprite = get_node("Sprite3D")
onready var passiveInteractionArea = get_node("PassiveInteractionArea")

var jump_force = 10
var shouldJump = false
var random_facing = Vector3(0, 0, -1) #default to facing forward
var facing_timer = 0
var facing_time_limit = 4

func _ready():
    set_process_input(true)
    set_physics_process(true)

    walk_speed = 6

func _process(delta):
    if global.pauseGame: return

    facing_timer += (delta*22)
    if facing_timer > facing_time_limit:
        random_facing = Vector3(randi()%3-1, 0, randi()%3-1)
        facing_timer = 0

func _physics_process(delta):
    #._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return
    .processPhysics(delta) # super
    
# @override
func processInputs(delta):
    .processInputs(delta)

    if shouldJump:
        vv = jump_force
        on_ground = false
        shouldJump = false

        player.magicJump()


    dir = Vector3(0.0, 0.0, 0.0)
    var curr_walk_speed = walk_speed
    if passiveInteractionArea.is_near_player:
        dir += random_facing
    else:
        var my_origin = global_transform.origin
        var player_origin = passiveInteractionArea.player_origin
        var scared_facing = (player_origin - my_origin).normalized()
        scared_facing.y = 0
        random_facing = scared_facing
        facing_timer = 0
        dir += scared_facing
        curr_walk_speed = walk_speed * 2

    hv = dir * curr_walk_speed
    
func isActive():
    return visible

func activate():
    barkSound.play()
    sprite.bark()
    shouldJump = true
