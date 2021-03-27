extends "res://scripts/ThrowableObject.gd"

onready var pomello = get_node("pomello")
onready var pomelloModel = get_node("pomello/Cylinder")

# @override
func repositionSelf():
    .repositionSelf()
    if is_held:
        pomelloModel.material_override.params_billboard_mode = 2
    else:
        pomelloModel.material_override.params_billboard_mode = 0

# @override
func rollStep(delta):
    .rollStep(delta)
    # TODO(jaketrower): Needs to be based on hv direction...
    pomello.rotation_degrees.z += hv.length()

