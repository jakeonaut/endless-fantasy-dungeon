extends Spatial

var mouseDown = false
var startClickPos = Vector2(0, 0)
var mouseDiff = 0

func _process(delta):
	rotate_y(mouseDiff * delta)
	mouseDiff = 0
	
func _input(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		mouseDown = ev.is_pressed()
		startClickPos = ev.pos
	elif (ev.type == InputEvent.MOUSE_MOTION):
		if (mouseDown):
			mouseDiff = ev.pos.x - startClickPos.x
			startClickPos = ev.pos
		
	

func _ready():
	set_process_input(true)
	set_process(true)
	# initialize variables