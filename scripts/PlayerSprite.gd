extends "Sprite.gd"

var vframe = 0
var hframe = 0
onready var parent = get_parent()

func ready():
	set_process(true)

func _process(delta):
	if parent.linear_velocity.x != 0 or parent.linear_velocity.z != 0:
		frame_delay = 0.2
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") \
	or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		frame_delay = 0.3
	else:
		frame_delay = 0.4
	animate(delta)

func setOverallsCostume():
	hframe = 4
	vframe = 0
	updateStartframe()

func setFloorGlitch():
	pass

func updateStartFrame():
	start_frame = (self.hframes * vframe) + hframe
	set_frame(start_frame)