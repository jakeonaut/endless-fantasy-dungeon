extends KinematicBody

onready var landSound = get_node("Sounds/LandSound")
onready var bumpSound = get_node("Sounds/BumpSound")

var terminal_vel = 32
var on_ground = true
var was_on_ground = true
var fallCounter = 0
var fallCountMax = 10
var take_fall_damage = false

var linear_velocity = Vector3()
var lv = linear_velocity

var grav = 80
var g = Vector3(0, -grav, 0)

var up = -g.normalized() # (up is against gravity)
var vv = up.dot(lv) # vertical velocity
var hv = lv - up * vv # horizontal velocity

func _ready():
    set_process_input(true)
    set_process(true)
    set_physics_process(true)

func _process(delta):
    pass

func _physics_process(delta):
    pass

func processPhysics(delta):
    lv = linear_velocity
    g = Vector3(0, -grav, 0)
    
    applyGravity(delta)
    
    up = -g.normalized() # (up is against gravity)
    vv = up.dot(lv) # vertical velocity
    hv = lv - up * vv # horizontal velocity
    
    # apply terminal velocity to fall speed
    if vv < -terminal_vel:
        vv = -terminal_vel
        fallCounter += 1
    
    processInputs()
        
    lv = hv + (up * vv)
    
    # move_and_slide automatically includes "delta"
    linear_velocity = move_and_slide(lv, -g.normalized())

    noFloorBelow()
    
    if not was_on_ground and on_ground: # I just landed!!
        landed()
        # Falling fast and far
        if vv == -terminal_vel and fallCounter >= fallCountMax: 
            landedFast()
        elif take_fall_damage == false:
            landedNormally()
        else:
            landedFromBounce()

    was_on_ground = on_ground
    
func applyGravity(delta):
    lv += g * delta

func processInputs():
    pass
    
func landed():
    pass

func landedFast():
    take_fall_damage = true
    bumpSound.play()

func landedNormally():
    landSound.play()

func landedFromBounce():
    take_fall_damage = false

func noFloorBelow():
    if is_on_floor():
        fallCounter = 0
        on_ground = true
    else:
        on_ground = false