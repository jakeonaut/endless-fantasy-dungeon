extends Node

func _ready():
    set_process(true)

func _process(delta):
    get_node("HeartsRect/HeartsText").text = str(global.numHearts)