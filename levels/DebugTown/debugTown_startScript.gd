extends "res://scripts/levelScript.gd"

func _ready():
    ._ready() #super

    # TODO(jaketrower): Should make a utility script
    # musicMaster.gd that controls stopping all players
    # and starting only the selected one.
    get_node("/root/DungeonThemePlayer").stop()
    get_node("/root/DebugTownThemePlayer").play()

    var player = get_node("Player")
    player.getCamera().rotateTo(0, true)
    player.getCamera().rotateXTo(-45, true)