extends Spatial

onready var player = get_tree().get_root().get_node("level/Player")
onready var staticBody = get_node("StaticBody")

func _ready():
    set_process(true)

func _process(delta):
    var px = player.global_transform.origin.x
    var py = player.global_transform.origin.y
    var pz = player.global_transform.origin.z
    var sx = self.global_transform.origin.x
    var sy = self.global_transform.origin.y
    var sz = self.global_transform.origin.z
    if py > sy + 1:
        staticBody.set_collision_mask_bit(1, true)
    else:
        staticBody.set_collision_mask_bit(1, false)
