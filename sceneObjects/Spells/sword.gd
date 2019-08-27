extends Spatial

onready var mySprite = get_node("Sprite3D")

var animation_counter = 0
export var frame_delay = 0.4
var start_frame = 0
var base_frame = start_frame
export var max_frames = 2

func _ready():
    set_process(true)

func preProcess():
    pass

func _process(delta):
    preProcess()
    animate(delta)
    
func animate(delta):
    animation_counter += delta
    if animation_counter >= frame_delay:
        animation_counter = 0
        var frame = mySprite.get_frame()

        if frame >= start_frame and frame < start_frame + max_frames - 1:
            mySprite.set_frame(frame+1)
        else:
            mySprite.set_frame(start_frame)