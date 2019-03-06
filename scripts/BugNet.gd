extends KinematicBody

onready var timer = get_node("Timer")
onready var player = get_tree().get_root().get_node("level/Player")
onready var playerArea = get_tree().get_root().get_node("level/Player/InteractionArea")
onready var myArea = get_node("Area")

var throw_speed = 0
var dir = Vector3(0.0, 0.0, -1) # forward??

var linear_velocity = Vector3()
var returning = false

func _ready():
    set_process(true)
    set_physics_process(true)
    visible = false

func throw(position, throw_dir, is_player_walking):
    dir = throw_dir
    throw_speed = 16
    if is_player_walking:
        throw_speed = 24
    visible = true
    self.translation.x = position.x
    self.translation.y = position.y
    self.translation.z = position.z
    timer.start()

func playerCatch():
    visible = false
    returning = false

func _process(delta):
    if not visible: return
    
    if timer.is_stopped():
        returning = true

func _physics_process(delta):
    if not visible: return
    
    var lv = linear_velocity
    var hv = lv # horizontal velocity

    # update dir to point to the player when returning
    if returning:
        dir = (player.translation - self.translation).normalized()
        var areas = myArea.get_overlapping_areas()
        for area in areas:
            if area == playerArea:
                playerCatch()

    # update x and z
    hv = dir.normalized() * throw_speed

    lv = hv

    # Now, actually do the move!!
    linear_velocity = move_and_slide(lv, -Vector3(0, -1, 0).normalized())