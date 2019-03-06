extends Sprite3D

var step = 2

func _ready():
    if get_node("..").isLocked:
        texture = load("res://assets/npcs/tootorialgrey.png")
        step = 1

func _process(delta):
    rotate_y(step*delta)
