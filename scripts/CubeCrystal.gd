extends Node

func _ready():
    set_process(true)

func _process(delta):
    var step = 3
    rotate_y(step*delta)
    rotate_x(step*delta)