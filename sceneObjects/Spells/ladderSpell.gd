extends KinematicBody

onready var transformSound = get_node("TransformSound")
onready var player = get_tree().get_root().get_node("level/Player")

func isActive():
    return visible

func activate():
    transformSound.play()
    visible = false

    player.glitch_form = player.GlitchForm.LADDER
