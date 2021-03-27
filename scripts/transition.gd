extends CanvasLayer

# https://fede0d.github.io/blog/2016/02/07/Godot-Extra-Tips-2.html

# STORE THE SCENE PATH
var path = ""
var was_i_interrupted = false

# PUBLIC FUNCTION. CALLED WHENEVER YOU WANT TO CHANGE SCENE
func fade_to(scn_path):
    was_i_interrupted = false
    self.path = scn_path # store the scene path
    get_node("AnimationPlayer").play("fade") # play the transition animation
# PUBLIC FUNCTION. CALLED WHENEVER YOU WANT TO CHANGE SCENE
func long_fade_to(scn_path):
    was_i_interrupted = false
    self.path = scn_path # store the scene path
    get_node("AnimationPlayer").play("long_fade") # play the long transition animation
# PUBLIC FUNCTION. CALLED WHENEVER YOU WANT TO CHANGE SCENE
func blink_fade_to(scn_path):
    was_i_interrupted = false
    self.path = scn_path # store the scene path
    get_node("AnimationPlayer").play("blink_fade") # play the blink transition animation

func interrupt():
    was_i_interrupted = true
    get_node("AnimationPlayer").stop()
    get_node("AnimationPlayer").seek(0, true)

# PRIVATE FUNCTION. CALLED AT THE MIDDLE OF THE TRANSITION ANIMATION
func change_scene():
    print(was_i_interrupted)
    if was_i_interrupted:
        was_i_interrupted = false
        return

    if self.path != "":
        get_tree().change_scene(self.path)
    if global.activeThrowableObject:
        global.activeThrowableObjectPath = global.activeThrowableObject.filename