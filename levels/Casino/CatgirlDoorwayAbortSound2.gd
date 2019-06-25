extends AudioStreamPlayer

func _ready():
    pass

func activateScript():
    var myNpc = get_node("../../..")
    # capitalization matters...
    myNpc.textBox = myNpc.get_node("FinalTextBox/TextBox")
    if global.memory.has("numCoins"):
        global.memory["numCoins"] -= 20
    else:
        global.memory["numCoins"] = -20
    myNpc.walkOutOfDoorway = 1