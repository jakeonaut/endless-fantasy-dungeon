extends KinematicBody

onready var transformSound = get_node("TransformSound")
onready var player = get_parent().get_node("Player")

func _ready():
    pass

func interact():
    if visible:
        transformSound.play()
        player.bugTransform()
        hide()
        set_collision_mask_bit(1, false)