extends Area


func ready():
    set_process(true)

func _process(delta):
    var areas = get_overlapping_areas()

    var shortest_dist = 999 # zero escape saga
    var nearest_area = null
    var shortest_passive_dist = 999
    var nearest_passive_area = null
    # find the nearest active area and passive area
    for area in areas:
        if area.has_method("isActive") and area.isActive():
            var dist = area.global_transform.origin.distance_to(global_transform.origin)
            if area.has_method("PassiveInteractActivate"):
                if dist < shortest_passive_dist:
                    shortest_passive_dist = dist
                    nearest_passive_area = area
            
            if area.has_method("InteractActivate"):
                if dist < shortest_dist:
                    shortest_dist = dist
                    nearest_area = area

    # give priority to active area if user pressing interact action
    if Input.is_action_just_pressed("ui_interact"):
        if nearest_area:
            nearest_area.InteractActivate()
        # Give secondary priority to held objects action. Should be redundant
        # when/if the for loop above catches the interaction area of held object
        elif global.activeThrowableObject:
            global.activeThrowableObject.InteractActivate()
    # otherwise, try to interact passive areas
    elif nearest_passive_area:
        nearest_passive_area.PassiveInteractActivate()
        