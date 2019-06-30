extends "res://scripts/NPC.gd"

onready var player = get_tree().get_root().get_node("level/Player")
onready var levelRoot = get_tree().get_root().get_node("level")

# TODO(jaketrower): doing stuff like this... is dangerous 
# see: https://www.reddit.com/r/godot/comments/ait6y8/preloading_in_godot_31_vs_30/
const save_point_resource = preload("res://sceneObjects/SavePoint.tscn")

# @override
func passiveActivate(delta):
    var px = player.global_transform.origin.x
    var py = player.global_transform.origin.y
    var pz = player.global_transform.origin.z
    var sx = self.global_transform.origin.x
    var sy = self.global_transform.origin.y
    var sz = self.global_transform.origin.z
    if player.just_landed and py > sy \
       and ((px+0.5>sx-0.5 and px+0.5<sx+0.5) or (px-0.5<sx+0.5 and px-0.5>sx-0.5)) \
       and ((pz+0.5>sz-0.5 and pz+0.5<sz+0.5) or (pz-0.5<sz+0.5 and pz-0.5>sz-0.5)):
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