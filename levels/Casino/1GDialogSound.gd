extends AudioStreamPlayer

func _ready():
    pass

func activateScript():
    if global.memory.has("numCoins"):
        global.memory["numCoins"] -= 1
    else:
        global.memory["numCoins"] = -1