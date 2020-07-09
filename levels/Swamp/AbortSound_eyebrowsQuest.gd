extends AudioStreamPlayer

func _ready():
    pass

func activateScript():
    transition.fade_to("res://levels/eyesbrows.tscn")

func isActive():
    # OVERRIDE ME... if you dare
    return true