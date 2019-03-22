extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    set_process(true)

func _process(delta):
    get_node("CoinRect/CoinText").text = str(global.numCoins)