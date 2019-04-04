extends CanvasLayer

# https://fede0d.github.io/blog/2016/02/07/Godot-Extra-Tips-2.html

# STORE THE SCENE PATH
var path = ""

# PUBLIC FUNCTION. CALLED WHENEVER YOU WANT TO CHANGE SCENE
func fade_to(scn_path):
    self.path = scn_path # store the scene path
    get_node("AnimationPlayer").play("fade") # play the transition animation

# PRIVATE FUNCTION. CALLED AT THE MIDDLE OF THE TRANSITION ANIMATION
func change_scene():
    global.activeInteractor = null
    global.activeThrowableObject = null
    global.activeSavePoint = null

    if path != "":
        get_tree().change_scene(path)
        musicPlayer.conductFromScenePath(path)