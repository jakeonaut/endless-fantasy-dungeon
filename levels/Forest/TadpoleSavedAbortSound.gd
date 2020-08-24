extends AudioStreamPlayer

func _ready():
    pass

func activateScript():
    get_node("../../../CubeCrystal").visible = true

func isActive():
    # OVERRIDE ME... if you dare
    return true