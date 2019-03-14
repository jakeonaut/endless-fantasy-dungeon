extends "res://scripts/levelScript.gd"

func _ready():
    ._ready() #super 
        
    var player = get_node("Player")
    player.getCamera().rotateTo(0)