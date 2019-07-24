extends "res://scripts/GameMover.gd"

onready var coinSound = get_node("coinSound")

var MIN_STEP = -2
var MAX_STEP = -12
var step = MIN_STEP

var disappearing = false
var disappearTimer = 12

var was_just_thrown = false
var throw_speed = 14
var jump_force = 10

func _ready():
    set_process(true)
    set_physics_process(true)
    grav = 0

func _process(delta):
    if is_visible():
        if disappearing:
            step = MAX_STEP
            translate(Vector3(0, -MIN_STEP*delta, 0))
            disappearTimer -= (delta*22)
            if disappearTimer <= 0: 
                hide()
                disappearing = false
                queue_free()
        else:
            step = MIN_STEP
        rotate_y(step*delta)

func _physics_process(delta):
    #._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    .processPhysics(delta)

func processInputs(delta):
    if was_just_thrown:
        on_ground = false
        was_just_thrown = false
        hv = Vector3(0, 0, throw_speed)
        vv = jump_force
        grav = 80
    elif on_ground: 
        hv = Vector3()

func isActive():
    return is_visible() and not disappearing

func passiveActivate(delta):
    coinSound.play()
    disappearing = true

    if global.memory.has("numCoins"):
        global.memory["numCoins"] += 1
    else: 
        global.memory["numCoins"] = 1