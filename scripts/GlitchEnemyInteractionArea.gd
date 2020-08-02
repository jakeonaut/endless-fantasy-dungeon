extends Area

onready var parent = get_parent()

func GetHitByBroom():
    if isActive():
        parent.getHitByBroom()

func isActive():
    return parent.visible
