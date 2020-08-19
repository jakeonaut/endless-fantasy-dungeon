extends AudioStreamPlayer

onready var player = get_tree().get_root().get_node("level/Player")

func _ready():
    pass

func activateScript():
    # OVERRIDE ME
    global.can_broom = true
    player.can_broom = true

func isActive():
    # OVERRIDE ME... if you dare
    return true