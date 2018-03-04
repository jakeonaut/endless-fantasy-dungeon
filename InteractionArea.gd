extends Area

func _ready():
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	var areas = get_overlapping_areas()
	if Input.is_action_pressed("ui_jump"):
		for i in range(len(areas)):
			