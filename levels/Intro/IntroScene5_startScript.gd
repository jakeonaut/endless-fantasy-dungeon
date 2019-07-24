extends "res://scripts/levelScript.gd"

func _ready():
    # ._ready() #super 
    
    get_node("/root/musicPlayer").stopAll()
    
    if not global.memory.has("intro_scene_5_goddess"):
        var player = get_node("Player")
        player.getCamera().rotateTo(44, true)
        player.getCamera().rotateXTo(-30, true)
        player.getCamera().changeToIsometric()
    else:
        var goddess = get_node("GoddessPreview")
        goddess.visible = false
        var collisionShape = goddess.get_node("CollisionShape")
        collisionShape.disabled = true