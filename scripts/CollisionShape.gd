extends CollisionShape


func _ready():
	set_process_input(true)

func _input_event(viewport, ev, shape_idx):
    if ev is InputEventMouseButton \
    and ev.button_index == BUTTON_LEFT \
    and ev.pressed:
        print("Clicked")