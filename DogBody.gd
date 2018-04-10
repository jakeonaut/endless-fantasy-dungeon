extends KinematicBody

var walk_speed = 8
var jump_force = 24
var grav = 80
var terminal_vel = 32
onready var camera = get_node("TheCamera") # the "camera"
var on_ground = true

var linear_velocity = Vector3()

func _ready():
	set_process(true)
	set_physics_process(true)
	
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
	
	# jump
	if is_on_floor() and Input.is_action_just_pressed("ui_jump"):
		vv = jump_force
	
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
		
	# rotate dir -45 deg about y axis
	#dir = dir.rotated(up, -0.79)
	
	# update x and z
	hv = dir.normalized() * walk_speed
		
	lv = hv + (up * vv)
	
	linear_velocity = move_and_slide(lv, -g.normalized())