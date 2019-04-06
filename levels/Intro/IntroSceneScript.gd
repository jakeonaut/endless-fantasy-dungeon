extends "res://scripts/levelScript.gd"

func _ready():
    ._ready() #super
        
    if not global.memory.has("game_has_started"):
        get_node("yellow/InteractionArea").InteractActivate()
        global.memory["game_has_started"] = true
    else:
        get_node("yellow/TextBox4/TextBox/Event").activateScript()