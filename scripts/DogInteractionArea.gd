extends Area

# onready var bugNet = get_node("../Items/BugNet")
# onready var player = get_node("..")

func ready():
    set_process(true)

func _process(delta):
    var hasInteracted = false
    
    var areas = get_overlapping_areas()
    if Input.is_action_just_pressed("ui_interact"):
        for area in areas:
            # TODO(jakeonaut): Only activate nearest area OR throwableObject carried
            if area.has_method("InteractActivate") and area.isActive() and not hasInteracted:
                area.InteractActivate()
                hasInteracted = true
    
        # if not hasInteracted:
        #	bugNet.throw(player.translation, player.facing, player.is_walking)

        # Should be redundant when/if the for loop above catches the interaction area
        # of the object you are holding
        if not hasInteracted:
            if global.activeThrowableObject:
                global.activeThrowableObject.InteractActivate()