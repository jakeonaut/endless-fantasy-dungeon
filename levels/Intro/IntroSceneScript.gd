extends "res://scripts/levelScript.gd"

func _ready():
    ._ready() #super
        
    # TODO(jakeonaut): Global variable for is_game_started??
    var npc = get_node("yellow")
    npc.get_node("InteractionArea").InteractActivate()