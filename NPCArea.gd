extends Area

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)

func _input_event(viewport, ev, shape_idx):
    if ev is InputEventMouseButton \
    and ev.button_index == BUTTON_LEFT \
    and ev.pressed:
        print("Clicked")
