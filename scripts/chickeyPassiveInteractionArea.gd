extends Area

var is_near_doggo = false
var dog_origin = Vector3(0, 0, 0)

func _ready():
    set_process(true)

func _process(delta):
    is_near_doggo = false
    var areas = get_overlapping_areas()
    for area in areas:
        if area.is_in_group("dog"):
            is_near_doggo = true
            # would this work if there are multiple doggos???
            var collision_shape = area.get_node("CollisionShape")
            dog_origin = collision_shape.global_transform.origin