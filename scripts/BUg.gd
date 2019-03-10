extends KinematicBody

onready var transformSound = get_node("TransformSound")
onready var player = get_parent().get_node("Player")

func isActive():
    return visible

func activate():
    transformSound.play()
    player.bugTransform()
    hide()
    set_collision_mask_bit(1, false)