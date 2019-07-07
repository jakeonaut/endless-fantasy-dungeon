extends "res://scripts/GameMover.gd"

onready var player = get_tree().get_root().get_node("level/Player")
onready var textBox = get_node("NPC TextBox").get_node("TextBox")
var target = null
var target_idx = 0
onready var targetContainer = get_node("Targets")

var jump_force = 45
var jump_timer = 0
var jump_time_limit = 20
var started_jumping = false
var hop_speed = 5

func _ready():
    set_process(true)
    set_physics_process(true)

    set_collision_mask_bit(1, true)

    target = get_node("./Targets/Target1")

func isActive():
    return visible

func activate():
    if global.activeInteractor == null:
        global.activeInteractor = textBox
        textBox.interact()

func passiveActivate(delta):
    pass

func stopPassiveActivate():
    pass

func _physics_process(delta):
    #._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    var bitMask = player.get_collision_layer_bit(1)
    player.set_collision_layer_bit(1, false)
    .processPhysics(delta)
    player.set_collision_layer_bit(1, bitMask)

# @override
func processInputs(delta):
    if on_ground:
        hv = Vector3(0, 0, 0)
        jump_timer += (delta*22)
        if jump_timer >= jump_time_limit:
            jump_timer = 0

            vv = (2*jump_force) / 3
            started_jumping = true
    elif started_jumping:
        # calculate vector between myself and my target (on x/z)
        var t = target.global_transform.origin
        var s = self.global_transform.origin
        hv = Vector3(t.x - s.x, 0, t.z - s.z) * hop_speed
    
# @override
func landed():
    if started_jumping:
        started_jumping = false

        target_idx += 1
        if target_idx >= targetContainer.get_child_count():
            target_idx = 0
        target = targetContainer.get_child(target_idx)