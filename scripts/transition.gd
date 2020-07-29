extends CanvasLayer

# https://fede0d.github.io/blog/2016/02/07/Godot-Extra-Tips-2.html

# STORE THE SCENE PATH
var path = ""

# PUBLIC FUNCTION. CALLED WHENEVER YOU WANT TO CHANGE SCENE
func fade_to(scn_path):
    self.path = scn_path # store the scene path
    get_node("AnimationPlayer").play("fade") # play the transition animation
# PUBLIC FUNCTION. CALLED WHENEVER YOU WANT TO CHANGE SCENE
func long_fade_to(scn_path):
    self.path = scn_path # store the scene path
    get_node("AnimationPlayer").play("long_fade") # play the long transition animation
# PUBLIC FUNCTION. CALLED WHENEVER YOU WANT TO CHANGE SCENE
func blink_fade_to(scn_path):
    self.path = scn_path # store the scene path
    get_node("AnimationPlayer").play("blink_fade") # play the blink transition animation

# PRIVATE FUNCTION. CALLED AT THE MIDDLE OF THE TRANSITION ANIMATION
func change_scene():
    if self.path != "":
        get_tree().change_scene(self.path)
        if global.activeThrowableObject:
            global.activeThrowableObjectPath = global.activeThrowableObject.filename