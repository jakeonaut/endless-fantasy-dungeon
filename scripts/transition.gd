extends CanvasLayer

# https://fede0d.github.io/blog/2016/02/07/Godot-Extra-Tips-2.html

# STORE THE SCENE PATH
var path = ""

# PUBLIC FUNCTION. CALLED WHENEVER YOU WANT TO CHANGE SCENE
func fade_to(scn_path):
    self.path = scn_path # store the scene path
    get_node("AnimationPlayer").play("fade") # play the transition animation
func long_fade_to(scn_path):
    self.path = scn_path # store the scene path
    get_node("AnimationPlayer").play("long_fade") # play the long transition animation

# PRIVATE FUNCTION. CALLED AT THE MIDDLE OF THE TRANSITION ANIMATION
func change_scene():
    if self.path != "":
        get_tree().change_scene(self.path)

        # only treat new rooms as "save points" until we introduce save points.
        if not global.memory.has("active_save_point"):
            global.memory["roomPath"] = self.path
            global.saveGame()