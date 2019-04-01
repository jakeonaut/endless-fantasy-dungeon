extends Sprite3D

var step = 2

func _process(delta):
    rotate_y(step*delta)
