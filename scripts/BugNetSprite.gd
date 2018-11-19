extends Sprite3D

var animation_counter = 0
var animation_count_max = 0.1
var glitch_vframe = 0
var costume_hframe = 0
var myframe = 0
var max_frames = 4
onready var parent = get_parent()

func ready():
	set_process(true)

func _process(delta):
	animation_count_max = 0.05
	
	animate(delta)
	
func animate(delta):
	animation_counter += delta
	if animation_counter >= animation_count_max:
		animation_counter = 0
		var frame = get_frame()
		
		# iterate over the max frame count
		if frame >= myframe and frame < myframe + max_frames - 1:
			set_frame(frame+1)
		else:
			set_frame(myframe)