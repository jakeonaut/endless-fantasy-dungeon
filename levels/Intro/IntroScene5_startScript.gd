extends "res://scripts/levelScript.gd"

func _ready():
    ._ready() #super 
    
    get_node("/root/musicPlayer").stop()
        
    var player = get_node("Player")
    player.getCamera().rotateTo(0, true)
    player.getCamera().rotateXTo(-30, true)