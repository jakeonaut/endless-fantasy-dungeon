extends Sprite3D

var step = 2
var flip_timer = 0
var flip_time_limit = 40
var flipped = false
export var flippable = false

func _ready():
    flip_timer = (flip_time_limit/2)

func _process(delta):
    if flipped:
        rotate_y(-step*delta)
    else:
        rotate_y(step*delta)

    if flippable:
        step = 1
        flip_timer += (delta*22)
        if flip_timer >= flip_time_limit:
            flip_timer = 0
            flipped = not flipped
