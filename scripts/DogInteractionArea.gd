extends Area

func ready():
	set_process(true)

func _process(delta):
	var areas = get_overlapping_areas()
	if Input.is_action_just_pressed("ui_interact"):
		for area in areas:
			# TODO(jakeonaut): Only activate nearest area
			if area.has_method("InteractActivate"):
				area.InteractActivate()