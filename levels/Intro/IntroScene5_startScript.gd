extends "res://scripts/levelScript.gd"

func _ready_impl():
    # ._ready() #super 
    
    ._ready_impl()
    # if not global.memory.has("intro_scene_goddess"):
        # var player = get_node("Player")
        # player.getCamera().rotateTo(44, true)
        # player.getCamera().rotateXTo(-30, true)
        # player.getCamera().changeToIsometric()
    if global.memory.has("intro_scene_goddess"):
        var goddess = get_node("GoddessPreview")
        goddess.visible = false
        var collisionShape = goddess.get_node("CollisionShape")
        collisionShape.disabled = true
        var portalTownDungeon = get_node("portalTownDungeon")
        portalTownDungeon.isLocked = false