extends Area
        
func isActive():
    return get_parent().isActive()
    

func InteractActivate():
    get_parent().activate()