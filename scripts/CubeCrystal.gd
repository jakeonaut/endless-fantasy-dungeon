extends Spatial

func _ready():
    set_process(true)

func _process(delta):
    rotate_y(2*delta)
    rotate_x(1*delta)