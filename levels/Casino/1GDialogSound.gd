extends "res://scripts/AbortSound.gd"

# @override
func activateScript():
    if global.memory.has("numCoins"):
        global.memory["numCoins"] -= 1
    else:
        global.memory["numCoins"] = -1

# @override
func isActive():
    return global.memory.has("numCoins") and \
           global.memory["numCoins"] > 0