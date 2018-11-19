extends KinematicBody

enum Form {
	NORMAL,
	WORM
	FLOOR,
}
var form = Form.NORMAL

var walk_speed = 8
var lunge_speed = 16
var is_lunging = 0
var jump_force = 20
var climb_force = 10
var grav = 80
var terminal_vel = 32
onready var camera = get_node("CameraY") # the "camera"
onready var mySprite = get_node("Sprite3D")
onready var jumpSound = get_node("Sounds/JumpSound")
onready var landSound = get_node("Sounds/LandSound")
onready var bumpSound = get_node("Sounds/BumpSound")
var on_ground = true
var fallCounter = 0
var fallCountMax = 10
var take_fall_damage = false

var facing = Vector3(0, 0, -1) #default to facing forward
var is_walking = false

onready var wormSound = get_node("Sounds/WormSound")
onready var wormClimbSound = get_node("Sounds/WormClimbSound")
var wormClimbCounter = 0
var wormClimbCountMax = 40

var linear_velocity = Vector3()

func ready():
	set_process_input(true)
	set_process(true)
	set_physics_process(true)
	
func wearOveralls():
	mySprite.setCostumeFrame(2) # hframe for overalls
	jumpSound = get_node("Sounds/JumpOverallsSound")
	
func floorTransform():
	mySprite.setGlitchFrame(2) # vframe for floorGlitch
	form = Form.FLOOR
	
func bugTransform():
	pass # needs to be updated to work with hframe/vframe!!! could be a glitch or a costume ? [both?]

# Player needs to handle her own text boxes
func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		if is_activeTextboxMyChild():
			global.activeInteractor.interact()
			get_tree().set_input_as_handled()

func is_activeTextboxMyChild():
	var node = global.activeInteractor
	while node and node.get_node("..") != get_tree():
		if node == self: 
			return true
		node = node.get_node("..")
	return false
	
func _process(delta):
	if Input.is_action_pressed("ui_rotate_right"):
		camera.rotate_right()
	if Input.is_action_pressed("ui_rotate_left"):
		camera.rotate_left()
	if Input.is_action_pressed("ui_rotate_up"):
		camera.rotate_up()
	if Input.is_action_pressed("ui_rotate_down"):
		camera.rotate_down()
	
func _physics_process(delta):
	var lv = linear_velocity
	var g = Vector3(0, -grav, 0)
	
	if not on_ground:
		lv += g * delta # Apply gravity
	
	var up = -g.normalized() # (up is against gravity)
	var vv = up.dot(lv) # vertical velocity
	var hv = lv - up * vv # horizontal velocity
	
	# apply terminal velocity to fall speed
	if vv < -terminal_vel:
		vv = -terminal_vel
		fallCounter += 1
	
	var has_just_lunged = false
	# jump
	if Input.is_action_just_pressed("ui_jump") and not global.pauseMoveInput: 
		# Jump from the ground
		if is_lunging == 0:
			if form == Form.WORM:
				wormSound.play()
				vv = jump_force / 4
			else:
				vv = jump_force
				jumpSound.play()
			on_ground = false
			is_lunging = 1
		# Dash lunge
		elif is_lunging == 1:
			vv = jump_force / 2
			jumpSound.play()
			has_just_lunged = true
			is_lunging = 2
	elif take_fall_damage and form != Form.FLOOR:
		vv = jump_force
		take_fall_damage = false
		on_ground = false
	
	# Forward as seen by the camera (OpenGL convention)
	var view_forward = -camera.get_transform().basis.z
	var view_right = -camera.get_transform().basis.x
	# Forward as seen by the dog (???)
	var forward = Vector3(view_forward.x, 0.0, view_forward.z).normalized()
	var right = view_right
	
	var dir = Vector3(0.0, 0.0, 0.0)
	if Input.is_action_pressed("ui_left") and not global.pauseMoveInput:
		dir += right
	elif Input.is_action_pressed("ui_right") and not global.pauseMoveInput:
		dir -= right
	if Input.is_action_pressed("ui_up") and not global.pauseMoveInput:
		dir += forward
	elif Input.is_action_pressed("ui_down") and not global.pauseMoveInput:
		dir -= forward

	updateFacing(dir)
	
	# update x and z
	if is_lunging < 2:
		hv = dir.normalized() * walk_speed
	if has_just_lunged:
		hv = dir.normalized() * lunge_speed
		
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
		is_lunging = 0
		if vv == -terminal_vel and fallCounter >= fallCountMax: # Falling fast and far
			take_fall_damage = true
			bumpSound.play()
			
	if is_on_floor():
		fallCounter = 0
		on_ground = true
	elif form != Form.FLOOR:
		on_ground = false

func updateFacing(dir):
	if dir.x != 0 or dir.y != 0 or dir.z != 0:
		facing = dir
		is_walking = true
	else:
		is_walking = false