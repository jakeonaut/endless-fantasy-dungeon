extends "res://scripts/GameMover.gd"

onready var squawkSound = get_node("Sounds/BarkSound")
onready var sprite = get_node("Sprite3D")
onready var player = get_tree().get_root().get_node("level/Player")

var spawn_origin

var jump_force = 10
var shouldJump = false
var random_facing = Vector3(0, 0, -1) #default to facing forward
var facing_timer = 0
var facing_time_limit = 4

func _ready():
    set_process_input(true)
    set_physics_process(true)

    spawn_origin = self.global_transform.origin
    walk_speed = 4

func _process(delta):
    facing_timer += (delta*22)
    if facing_timer > facing_time_limit:
        random_facing = Vector3(randi()%3-1, 0, randi()%3-1)
        facing_timer = 0

func _physics_process(delta):
    #._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return
    .processPhysics(delta) # super

    if not on_ground and translation.y < -12:
        respawn()

func respawn():
    self.hv = Vector3(0, 0, 0)
    self.linear_velocity = Vector3(0, 0, 0)

    self.global_transform.origin = spawn_origin
    self.global_transform.origin.y += 2
    
# @override
func processInputs(delta):
    if shouldJump:
        vv = jump_force
        on_ground = false
        shouldJump = false

    dir = Vector3(0.0, 0.0, 0.0)
    dir += random_facing
    var curr_walk_speed = walk_speed
    hv = dir * curr_walk_speed
    
func isActive():
    return visible

func activate():
    squawkSound.play()
    shouldJump = true
