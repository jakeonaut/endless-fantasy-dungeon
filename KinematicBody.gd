extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var node = get_object_under_mouse()
		if node and node.has('collider') and node['collider'] == self:
			print(get_object_under_mouse()['collider'] == get_node("."))
		elif node and node.has('collider'):
			print("false?")
		else:
			print("null..")
		
# cast a ray from camera at mouse position, and get the object colliding with the ray
func get_object_under_mouse():
	var RAY_LENGTH = 15
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_from = get_node("../Camera").project_ray_origin(mouse_pos)
	var ray_to = ray_from + get_node("../Camera").project_ray_normal(mouse_pos) * RAY_LENGTH
	var space_state = get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection