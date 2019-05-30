extends Area

var is_touching_a_ladder = false
var is_touching_enemy = false

func _ready():
    set_process(true)

func _process(delta):
    var areas = get_overlapping_areas()
    is_touching_a_ladder = false
    is_touching_enemy = false
    for area in areas:
        if area.is_in_group("ladders"):
            is_touching_a_ladder = true
        if area.is_in_group("enemies"):
            is_touching_enemy = true