extends "Sprite.gd"

func _ready():
    set_process(true)
    start_frame = get_frame()
            
func bark():
    animation_counter = 0
    # Assume the bark static sprite is in the third H_FRAME
    set_frame(start_frame+2) 