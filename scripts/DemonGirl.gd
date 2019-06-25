extends "NPC.gd"

onready var player = get_tree().get_root().get_node("level/Player")

# @override
func passiveActivate(delta):
    if player.just_landed:
        player.take_fall_damage = true
        if player.bumpSound:
            player.bumpSound.play()
        # hide()
        # set_collision_mask_bit(1, false)
        