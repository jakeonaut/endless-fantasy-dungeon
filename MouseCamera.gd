extends Spatial

var mouseDown = false
var startClickPos = Vector2(0, 0)
var mouseDiff = 0
var target_rotation = 0
var current_rotation = 0
var step = 5

func _ready():
	set_process_input(true)
	set_process(true)

func _process(delta):
	if target_rotation > current_rotation:
		current_rotation += step*delta
		rotate_y(step * delta)
		if current_rotation > target_rotation:
			current_rotation = target_rotation
	elif target_rotation < current_rotation:
		current_rotation -= step*delta
		rotate_y(-step * delta)
		if current_rotation < target_rotation:
			current_rotation = target_rotation
			
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
			
func rotate_right():
	target_rotation -= 1.5708
	
func rotate_left():
	target_rotation += 1.5708