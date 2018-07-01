extends KinematicBody

enum Form {
	NORMAL,
	WORM
}
var form = Form.NORMAL

var walk_speed = 8
var jump_force = 20
var climb_force = 10
var grav = 80
var terminal_vel = 32
onready var camera = get_node("TheCamera") # the "camera"
onready var jumpSound = get_node("JumpSound")
onready var landSound = get_node("LandSound")
onready var bumpSound = get_node("BumpSound")
var on_ground = true
var fallCounter = 0
var fallCountMax = 10
var take_fall_damage = false

onready var wormSound = get_node("WormSound")
onready var wormClimbSound = get_node("WormClimbSound")
var wormClimbCounter = 0
var wormClimbCountMax = 40

var linear_velocity = Vector3()

func _ready():
	set_process(true)
	set_physics_process(true)
	
func bugTransform():
	var sprite = get_node("Sprite3D")
	sprite.texture =  load("res://assets/playerBug0000.png")
	form = Form.WORM
	
func _process(delta):
	if Input.is_action_just_pressed("ui_rotate_right"):
		camera.rotate_right()
	if Input.is_action_just_pressed("ui_rotate_left"):
		camera.rotate_left()
	
func _physics_process(delta):
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
	
	# jump
	if Input.is_action_just_pressed("ui_jump"): 
	#is_on_floor() and Input.is_action_just_pressed("ui_jump"):
		if form == Form.WORM:
			wormSound.play()
			vv = jump_force / 4
		else:
			vv = jump_force
			jumpSound.play()
			
	elif take_fall_damage:
		vv = jump_force
		take_fall_damage = false
	
	# Forward as seen by the camera (OpenGL convention)
	var view_forward = -camera.get_transform().basis.z
	var view_right = -camera.get_transform().basis.x
	# Forward as seen by the dog (???)
	var forward = Vector3(view_forward.x, 0.0, view_forward.z).normalized()
	var right = view_right
	
	var dir = Vector3(0.0, 0.0, 0.0)
	if Input.is_action_pressed("ui_left"):
		dir += right
	elif Input.is_action_pressed("ui_right"):
		dir -= right
	if Input.is_action_pressed("ui_up"):
		dir += forward
	elif Input.is_action_pressed("ui_down"):
		dir -= forward
	
	# update x and z
	hv = dir.normalized() * walk_speed
		
	lv = hv + (up * vv)
	
	var was_on_floor = is_on_floor()
	# move_and_slide automatically includes "delta"
	linear_velocity = move_and_slide(lv, -g.normalized())
	
	if form == Form.WORM and is_on_wall() and (dir.x != 0 or dir.y != 0 or dir.z != 0):
		linear_velocity.y = climb_force
		wormClimbCounter += 1
		if wormClimbCounter >= wormClimbCountMax:
			wormClimbSound.play()
			wormClimbCounter = 0
	else:
		wormClimbCounter = wormClimbCountMax
	
	if not was_on_floor and is_on_floor(): # I just landed!!
		if vv == -terminal_vel and fallCounter >= fallCountMax: # Falling fast and far
			take_fall_damage = true
			bumpSound.play()
			
	if is_on_floor():
		fallCounter = 0