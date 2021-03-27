extends "res://scripts/GameMover.gd"

onready var barkSound = get_node("Sounds/BarkSound")
onready var sniffSound = get_node("Sounds/SniffSound")
onready var player = get_tree().get_root().get_node("level/Player")
onready var sprite = get_node("Sprite3D")
onready var smallPassiveInteractionArea = get_node("SmallInteractionArea")
onready var passiveInteractionArea = get_node("PassiveInteractionArea")
onready var passiveDetectionInteractionArea = get_node("PassiveDetectionInteractionArea")

export var stationary = false

var jump_force = 10
var shouldJump = false
var random_facing = Vector3(0, 0, -1) #default to facing forward
var facing_timer = 0
var facing_time_limit = 4
var is_sniffing = false

func _ready():
    set_process_input(true)
    set_physics_process(true)
    if stationary: walk_speed = 0

func _process(delta):
    if global.pauseGame: return

    walk_speed = 7
    if stationary: walk_speed = 0

    # facing_timer += (delta*22)
    # if facing_timer > facing_time_limit:
    #   random_facing = Vector3(randi()%3-1, 0, randi()%3-1)
    #   facing_timer = 0

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

        if player.is_holding_chicken:
            player.magicJump()


    dir = Vector3(0.0, 0.0, 0.0)
    var curr_walk_speed = walk_speed
    if passiveDetectionInteractionArea.is_near_player and not passiveInteractionArea.is_near_player:
        var my_origin = global_transform.origin
        var player_origin = passiveInteractionArea.player_origin
        var scared_facing = (player_origin - my_origin).normalized()
        scared_facing.y = 0
        # random_facing = scared_facing
        # facing_timer = 0
        dir += scared_facing
        curr_walk_speed = walk_speed * 2

    if smallPassiveInteractionArea.is_near_player:
        if not is_sniffing:
            sniffSound.play()
            is_sniffing = true
    else:
        sniffSound.stop()
        is_sniffing = false


    hv = dir * curr_walk_speed
    
func isActive():
    return visible

func activate():
    barkSound.play()
    sprite.bark()
    shouldJump = true
