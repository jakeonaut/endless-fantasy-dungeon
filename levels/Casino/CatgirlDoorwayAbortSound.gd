extends AudioStreamPlayer

func _ready():
    pass

func activateScript():
    if global.numCoins >= 20:
        global.numCoins -= 20
        get_node("../Text").set_bbcode(
            "we all have needs.\nand that's ok.")