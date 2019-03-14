extends Sprite3D

var animation_counter = 0
var animation_count_max = 0.1
var vframe = 0
var hframe = 0
export var myframe = 0
var max_frames = 2

onready var parent = get_parent()

func ready():
	set_process(true)

func _process(delta):
	if parent.linear_velocity.x != 0 or parent.linear_velocity.z != 0:
		animation_count_max = 0.1
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") \
	or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		animation_count_max = 0.2
	else:
		animation_count_max = 0.3
	animate(delta)

func setOverallsCostume():
	hframe = 4
	vframe = 0
	updateMyframe()

func setFloorGlitch():
	pass

func updateMyframe():
	myframe = (self.hframes * vframe) + hframe
	set_frame(myframe)
	
func animate(delta):
	animation_counter += delta
	if animation_counter >= animation_count_max:
		animation_counter = 0
		var frame = get_frame()
		
		if frame >= myframe and frame < myframe + max_frames - 1:
			set_frame(frame+1)
		else:
			set_frame(myframe)