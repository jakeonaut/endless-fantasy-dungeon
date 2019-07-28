extends KinematicBody

onready var transformSound = get_node("TransformSound")
onready var player = get_tree().get_root().get_node("level/Player")
onready var levelRoot = get_tree().get_root().get_node("level")

# TODO(jaketrower): doing stuff like this... is dangerous 
# see: https://www.reddit.com/r/godot/comments/ait6y8/preloading_in_godot_31_vs_30/
const twin_resource = preload("res://sceneObjects/Spells/PlayerTwin.tscn")

func isActive():
    return visible

func activate():
    transformSound.play()
    visible = false

    player.glitch_form = player.GlitchForm.TWIN
    player.faceDown()
    
    var twin = twin_resource.instance()
    levelRoot.add_child(twin)
    twin.translation = translation