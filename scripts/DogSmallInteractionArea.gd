extends Area

var is_touching_a_ladder = false

func ready():
    set_process(true)

func _process(delta):
    var areas = get_overlapping_areas()
    is_touching_a_ladder = false
    for area in areas:
        if area.has_method("isALadder") and area.isALadder():
            is_touching_a_ladder = true