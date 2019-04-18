extends Node

func _ready():
    set_process(true)

func _process(delta):
    get_node("CoinRect/CoinText").text = str(global.numCoins)