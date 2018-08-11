extends Area

onready var playerArea = get_parent().get_parent().get_node("Player/InteractionArea")

var interactingWithPlayer = false

func _ready():
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	if interactingWithPlayer:
		# Conversation finished naturally
		if global.activeInteractor == null:
			interactingWithPlayer = false
		# Player walked away, or was teleported/etc.
		elif not self.touchingPlayer():
			global.activeInteractor.abort()
			interactingWithPlayer = false
			
func _input_event(camera, ev, pos, normal, shape_idx):
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT:
		print("clicked... finally3")
		
func touchingPlayer():
	var areas = get_overlapping_areas()
	for area in areas:
		if area == playerArea:
			return true
	return false

	
func InteractActivate():
	if global.activeInteractor == null:
		interactingWithPlayer = true
	get_parent().interact()