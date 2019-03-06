extends Area

func isActive():
    return get_parent().isActive()

func PassiveInteractActivate():
    get_parent().activate()