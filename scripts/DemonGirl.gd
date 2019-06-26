extends "NPC.gd"

onready var player = get_tree().get_root().get_node("level/Player")
onready var levelRoot = get_tree().get_root().get_node("level")

# TODO(jaketrower): doing stuff like this... is dangerous 
# see: https://www.reddit.com/r/godot/comments/ait6y8/preloading_in_godot_31_vs_30/
const save_point_resource = preload("res://sceneObjects/SavePoint.tscn")

# @override
func passiveActivate(delta):
    if player.just_landed:
        player.take_fall_damage = true
        if player.bumpSound:
            player.bumpSound.play()
        hide()
        set_collision_mask_bit(1, false)
        spawnSavepoint()
        
func spawnSavepoint():
    var newSavePoint = save_point_resource.instance()
    levelRoot.add_child(newSavePoint)
    newSavePoint.translation = translation
    newSavePoint.passiveActivate(0)