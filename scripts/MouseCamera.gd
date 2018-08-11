extends Spatial

var mouseDown = false
var startClickPos = Vector2(0, 0)
var mouseDiffX = 0
var mouseDiffY = 0
# always either deg2rad(0, 90, 180, or 270)
var real_rotation_target = 0
var target_rotation = 0
var rstep = 90
# steps up/down to target_rotation
var current_rotation = 0
var is_rotating = false

func ready():
	set_process_input(true)
	set_process(true)
	
func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT:
		mouseDown = ev.is_pressed()
		startClickPos = ev.position
	elif ev is InputEventMouseMotion:
		if mouseDown:
			mouseDiffX = startClickPos.x - ev.position.x
			mouseDiffY = startClickPos.y - ev.position.y
			startClickPos = ev.position

func _process(delta):
	#var diff = abs(target_rotation - current_rotation)
	var step = 4 #max(min(diff*6, 10), 2)
	
	if target_rotation > current_rotation:
		current_rotation += step*delta
		rotate_y(step * delta)
		if current_rotation > target_rotation:
			self.tryNormalizeCurrent()
	elif target_rotation < current_rotation:
		current_rotation -= step*delta
		rotate_y(-step * delta)
		if current_rotation < target_rotation:
			self.tryNormalizeCurrent()
			
	rotate_y(mouseDiffX * delta)
	# rotate_x(mouseDiffY * delta)
	mouseDiffX = 0
	mouseDiffY = 0
	
func forceRotation(degrees, step):
	target_rotation += deg2rad(degrees)
	real_rotation_target = rotation_degrees.y + degrees
	is_rotating = true
	
	# nudge it along
	target_rotation += step
	rotate_y(step)
			
func rotate_left():
	if not is_rotating:
		target_rotation += deg2rad(rstep)
		real_rotation_target = rotation_degrees.y + rstep
		is_rotating = true
	
func rotate_right():
	if not is_rotating:
		target_rotation -= deg2rad(rstep)
		real_rotation_target = rotation_degrees.y - rstep
		is_rotating = true
	
func tryNormalizeCurrent():
	is_rotating = false
	if abs(target_rotation - current_rotation) < 1:
		self.normalizeTarget()
		current_rotation = target_rotation
	
func normalizeTarget():
	while target_rotation < 0:
		target_rotation += deg2rad(360)
	while target_rotation > deg2rad(360):
		target_rotation -= deg2rad(360)
		
	rotation_degrees.y = real_rotation_target
		
	var rotation = rad2deg(target_rotation)
	rotation = int(round(rotation/rstep))*rstep
	target_rotation = deg2rad(rotation)