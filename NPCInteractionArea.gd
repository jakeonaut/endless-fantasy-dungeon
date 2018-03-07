extends Area

onready var playerArea = get_parent().get_parent().get_node("Player/InteractionArea")

func _ready():
	set_process_input(true)

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed \
	and touchingPlayer():
		InteractActivate()
		
func touchingPlayer():
	var areas = get_overlapping_areas()
	for area in areas:
		if area == playerArea:
			return true
	return false

	
func InteractActivate():
	get_parent().interact()