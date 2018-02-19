extends Spatial

var mouseDown = false
var startClickPos = Vector2(0, 0)
var mouseDiff = 0

func _ready():
	set_process_input(true)
	set_process(true)

func _process(delta):
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