extends Node

func activate():
    var portdoor = get_tree().get_root().get_node("level/portal3")
    portdoor.isLocked = false
