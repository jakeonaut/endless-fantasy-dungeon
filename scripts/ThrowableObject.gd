extends KinematicBody

onready var pickupSound = get_node("Sounds/PickupSound")
onready var throwSound = get_node("Sounds/ThrowSound")
onready var landSound = get_node("Sounds/LandSound")
onready var bumpSound = get_node("Sounds/BumpSound")
onready var player = get_parent().get_node("Player")

var is_held = false
var was_just_thrown = false

var throw_speed = 16
var jump_force = 10
var grav = 80
var terminal_vel = 32
var on_ground = true
var was_on_ground = true
var fallCounter = 0
var fallCountMax = 10
var take_fall_damage = false
var linear_velocity = Vector3()

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if is_held:
		self.translation = player.translation
		self.translation.y += 3
		return

	# TODO(jaketrower): Make common script
	var lv = linear_velocity
	var g = Vector3(0, -grav, 0)
	
	lv += g * delta # Apply gravity
	
	var up = -g.normalized() # (up is against gravity)
	var vv = up.dot(lv) # vertical velocity
	var hv = lv - up * vv # horizontal velocity
	
	# apply terminal velocity to fall speed
	if vv < -terminal_vel:
		vv = -terminal_vel
		fallCounter += 1

	if take_fall_damage:
		vv = jump_force
		on_ground = false

	if was_just_thrown:
		was_just_thrown = false
		hv = player.facing.normalized() * throw_speed
	elif on_ground: 
		hv = Vector3()

	# combine vectors before applying on move_and_slide
	lv = hv + (up * vv)

	# move_and_slide automatically includes "delta"
	linear_velocity = move_and_slide(lv, -g.normalized())

	if is_on_floor():
		fallCounter = 0
		on_ground = true
	else:
		on_ground = false

	if not was_on_ground and on_ground: # I just landed!!
		# Falling fast and far
		if vv == -terminal_vel and fallCounter >= fallCountMax: 
			take_fall_damage = true
			bumpSound.play()
		elif take_fall_damage == false:
			landSound.play()
		else:
			take_fall_damage = false
			
	was_on_ground = on_ground


func isActive():
	return visible

func interact():
	if not is_held:
		pickupSound.play()
		is_held = true
	else:
		throwSound.play()
		is_held = false
		was_just_thrown = true
