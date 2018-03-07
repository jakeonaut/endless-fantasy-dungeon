extends TextureRect

func _ready():
	set_process_input(true)

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		self.hide()