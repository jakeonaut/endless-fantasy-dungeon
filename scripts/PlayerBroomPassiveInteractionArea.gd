extends Area

onready var broomGrandparent = get_parent().get_parent()

func _ready():
    set_process(true)

func _process(delta):

    if isActive():
        var areas = get_overlapping_areas()
        for area in areas:
            if area.is_in_group("enemies") and area.has_method("GetHitByBroom"):
                area.GetHitByBroom()

func isActive():
    return broomGrandparent.visible