extends Sprite3D

var animation_counter = 0
var animation_count_max = 0.4
var start_frame = 0

func _ready():
    set_process(true)
    start_frame = get_frame()
    

func _process(delta):
    animate(delta)
    rotate_y(delta)
    
func animate(delta):
    animation_counter += delta
    if animation_counter >= animation_count_max:
        animation_counter = 0
        animation_count_max = rand_range(0.1, 1.0)
        var frame = get_frame()
        if frame == start_frame:
            set_frame(start_frame+1)
        elif frame == start_frame+1:
            set_frame(start_frame)