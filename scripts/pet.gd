extends "res://scripts/GameMover.gd"

onready var barkSound = get_node("Sounds/BarkSound")
onready var sprite = get_node("Sprite3D")

var jump_force = 10
var shouldJump = false

func _ready():
    set_process_input(true)
    set_physics_process(true)

func _physics_process(delta):
    .processPhysics(delta) # super
    
# @override
func processInputs():
    if shouldJump:
        vv = jump_force
        on_ground = false
        shouldJump = false    
    
func _input(event):
    if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
        if self.visible and (is_self_under_mouse() or is_activeTextboxMyChild()):
            self.interact()
            get_tree().set_input_as_handled()

func is_activeTextboxMyChild():
    var node = global.activeInteractor
    while node and node.get_node("..") != get_tree():
        if node == self: 
            return true
        node = node.get_node("..")
    return false

# cast a ray from camera at mouse position, and get the object colliding with the ray
# from: https://www.reddit.com/r/godot/comments/8ft84k/get_clicked_object_in_3d/
func is_self_under_mouse():
    var RAY_LENGTH = 150
    var TheCamera = get_node("../Player/CameraY/CameraX/Camera")
    
    var mouse_pos = get_viewport().get_mouse_position()
    var ray_from = TheCamera.project_ray_origin(mouse_pos)
    var ray_to = ray_from + TheCamera.project_ray_normal(mouse_pos) * RAY_LENGTH
    var space_state = get_world().direct_space_state
    var hits = []
    # dummy fill
    var selection = true
    while selection:
        selection = space_state.intersect_ray(ray_from, ray_to, hits)
        if selection:
            # see if the selection collider is a child of me!! 
            var collider = selection.collider
            while collider and collider.get_node("..") != get_tree():
                if collider == self: 
                    return true
                collider = collider.get_node("..")
            # only gets here if the selection collider was not my child
            hits.append(selection.rid)
    return false

func interact():
    barkSound.play()
    sprite.bark()
    shouldJump = true
