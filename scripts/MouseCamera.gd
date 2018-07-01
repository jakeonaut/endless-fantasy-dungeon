extends Spatial

var mouseDown = false
var startClickPos = Vector2(0, 0)
var mouseDiff = 0
# always either deg2rad(0, 90, 180, or 270)
var real_rotation_target = 0
var target_rotation = 0
# steps up/down to target_rotation
var current_rotation = 0

func _ready():
	set_process_input(true)
	set_process(true)

func _process(delta):
	#var diff = abs(target_rotation - current_rotation)
	var step = 5 #max(min(diff*6, 10), 2)
	
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
			
	rotate_y(mouseDiff * delta)
	mouseDiff = 0
	
func _input(ev):
	if ev is InputEventMouseButton:
		mouseDown = ev.is_pressed()
		startClickPos = ev.position
	elif ev is InputEventMouseMotion:
		if (mouseDown):
			mouseDiff = startClickPos.x - ev.position.x
			startClickPos = ev.position
			
func rotate_left():
	target_rotation += deg2rad(90)
	real_rotation_target = rotation_degrees.y + 90
	
func rotate_right():
	target_rotation -= deg2rad(90)
	real_rotation_target = rotation_degrees.y - 90
	
func tryNormalizeCurrent():
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
	rotation = int(round(rotation/90))*90
	target_rotation = deg2rad(rotation)