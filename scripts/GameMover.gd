extends KinematicBody

onready var mySprite = get_node("Sprite3D")
onready var landSound = get_node("Sounds/LandSound")
onready var bumpSound = get_node("Sounds/BumpSound")
onready var skateSound = get_node("Sounds/SkateSound")

var terminal_vel = 32
var on_ground = true
var was_on_ground = true
var fallCounter = 0
var fallCountMax = 3
var take_fall_damage = false

var linear_velocity = Vector3()
var lv = linear_velocity

var grav = 80
var g = Vector3(0, -grav, 0)

var up = -g.normalized() # (up is against gravity)
var vv = up.dot(lv) # vertical velocity
var hv = lv - up * vv # horizontal velocity

var walk_speed = 8

var is_skating = false
var skateVector = Vector3(0, 0, 0)
var skateStartTimer = 0
var skateStartTimeLimit = 1
var skateActuallyStarted = false
var skateRotateTimer = 0
var skateRotateTimeLimit = 1
var speedBoostTimer = 0
var speedBoostTimeLimit = 2
var skate_origin = null
var is_touching_speed_boost = false
var speed_boost_angle = false
var speed_boost_origin = false

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
        fallCounter += (delta*22)
    
    processSkateInputs(delta)
    if not is_skating:
        processInputs(delta)
        
    lv = hv + (up * vv)
    
    # move_and_slide automatically includes "delta"
    linear_velocity = move_and_slide(lv, -g.normalized())

    postProcessSkateInputs(delta)
    postProcessInputs(delta)

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

func tryStartSkate():
    is_skating = true
    skateStartTimer = 0
    skateActuallyStarted = false

func processSkateInputs(delta):
    if is_touching_speed_boost:
        speedBoostTimer += (delta*22)
        if speedBoostTimer > speedBoostTimeLimit:
            skate_origin = null
            speedBoostTimer = 0
            is_skating = true
            skateStartTimer = 0
            skateActuallyStarted = false
            skateVector = Vector3(-1, 0, 0).rotated(Vector3(0, 1, 0), speed_boost_angle)
        elif not is_skating:
            if skate_origin == null:
                skate_origin = self.global_transform.origin
            self.global_transform.origin = self.global_transform.origin.linear_interpolate(
                speed_boost_origin, delta*11)
    else:
        speedBoostTimer = 0

    if is_skating:
        hv = skateVector.normalized() * walk_speed

        skateRotateTimer += delta*22
        if skateRotateTimer >= skateRotateTimeLimit:
            skateRotateTimer = 0
            if mySprite.isFacingDown(): mySprite.faceLeft()
            elif mySprite.isFacingLeft(): mySprite.faceUp()
            elif mySprite.isFacingUp(): mySprite.faceRight()
            elif mySprite.isFacingRight(): mySprite.faceDown()

        skateStartTimer += delta*22
        if skateStartTimer >= skateStartTimeLimit and not skateActuallyStarted:
            skateSound.play()
            skateActuallyStarted = true

func processInputs(delta):
    pass

func postProcessSkateInputs(delta):
    if is_skating \
    and linear_velocity.x < walk_speed/2 and linear_velocity.x > -walk_speed/2 \
    and linear_velocity.z < walk_speed/2 and linear_velocity.z > -walk_speed/2:
        is_skating = false
        mySprite.faceDown()
        skateRotateTimer = 0
        skateStartTimer = 0
        if skateActuallyStarted:
            bumpSound.play()
            skateActuallyStarted = false

func postProcessInputs(delta):
    pass
    
func landed():
    pass

func landedFast():
    take_fall_damage = true
    if bumpSound: bumpSound.play()

func landedNormally():
    if landSound: landSound.play()

func landedFromBounce():
    take_fall_damage = false

func noFloorBelow():
    if is_on_floor():
        fallCounter = 0
        on_ground = true
    else:
        on_ground = false