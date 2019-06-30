extends Area

var is_touching_water = false

func _ready():
    set_process(true)
        
func isActive():
    return get_parent().isActive()

func InteractActivate():
    get_parent().activate()

func _process(delta):
    var areas = get_overlapping_areas()
    is_touching_water = false
    for area in areas:
        if area.is_in_group("water"):
            is_touching_water = true