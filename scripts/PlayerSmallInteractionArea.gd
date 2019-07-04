extends Area

var is_touching_a_ladder = false
var is_touching_enemy = false
var is_touching_speed_boost = false
var is_touching_water = false
var water_y = 0
var speed_boost_angle = 0
var speed_boost_origin = Vector3(0,0,0)

func _ready():
    set_process(true)

func _process(delta):
    var areas = get_overlapping_areas()
    is_touching_a_ladder = false
    is_touching_enemy = false
    is_touching_speed_boost = false
    is_touching_water = false
    for area in areas:
        if area.is_in_group("ladders"):
            is_touching_a_ladder = true
        if area.is_in_group("enemies"):
            is_touching_enemy = true
        if area.is_in_group("speedboosts"):
            is_touching_speed_boost = true
            speed_boost_angle = area.get_node("..").rotation.y
            speed_boost_origin = area.get_node("..").global_transform.origin
        if area.is_in_group("water"):
            var collision_shape = area.get_node("CollisionShape")
            is_touching_water = true
            water_y = collision_shape.global_transform.origin.y + (collision_shape.get_shape().get_extents().y/2)