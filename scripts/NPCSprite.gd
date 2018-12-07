extends Sprite3D

var animation_counter = 0
var animation_count_max = 0.4

func _ready():
    set_process(true)

func _process(delta):
    animate(delta)
    rotate_y(delta)
    
func animate(delta):
    animation_counter += delta
    if animation_counter >= animation_count_max:
        animation_counter = 0
        var frame = get_frame()
        if frame == 0:
            set_frame(1)
        elif frame == 1:
            set_frame(0)