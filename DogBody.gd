extends KinematicBody

var walk_speed = 8
var jump_force = 16
var y_vel = 0
var grav = 1
var terminal_vel = 16
onready var camera = get_node("CollisionShape/Sprite3D/Spatial") # the "camera"
var on_ground = true

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	walkAround(delta)
	jumpGravity(delta)
	
func jumpGravity(delta):
	on_ground = false
	if move_and_collide(Vector3(0.0, y_vel * delta, 0.0)):
		on_ground = true
		y_vel = 0.0
	
	# jump
	if Input.is_action_pressed("ui_jump") and on_ground:
		on_ground = false
		y_vel = jump_force
	elif not on_ground:
		y_vel -= grav
		if y_vel < -terminal_vel:
			y_vel = -terminal_vel
		
func walkAround(delta):
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
	move_and_collide(dir.normalized() * (walk_speed * delta))