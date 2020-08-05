extends Area

var is_near_player = false
var player_origin = Vector3(0, 0, 0)

func _ready():
    set_process(true)

func _process(delta):
    is_near_player = false
    var areas = get_overlapping_areas()
    for area in areas:
        if area.is_in_group("player"):
            is_near_player = true
            var collision_shape = area.get_node("CollisionShape")
            player_origin = collision_shape.global_transform.origin