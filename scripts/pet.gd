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
    
func isActive():
    return visible

func activate():
    barkSound.play()
    sprite.bark()
    shouldJump = true
