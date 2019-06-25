extends Node

func _ready():
    set_process(true)

func _process(delta):
    var numCoins = global.memory["numCoins"] if global.memory.has("numCoins") else 0
    get_node("CoinRect/CoinText").text = str(numCoins)