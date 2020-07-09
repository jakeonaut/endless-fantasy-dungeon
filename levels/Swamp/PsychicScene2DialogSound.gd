extends AudioStreamPlayer

func _ready():
    pass

func activateScript():
    var sprite3d = get_node("../../../Sprite3D")
    sprite3d.frame = 0
    sprite3d.start_frame = 0

    var myTextBox = get_node("..")
    var myTextContainer = myTextBox.get_node("..")
    var myNpc = myTextContainer.get_node("..")
    myNpc.textBox = myTextBox

func isActive():
    # OVERRIDE ME... if you dare
    return true