extends Sprite3D

var animation_counter = 0
export var frame_delay = 0.4
# If true, this will override frame_delay after first frame change.
export var should_randomize_frame_delay = false
var start_frame = 0
export var max_frames = 2

func _ready():
    set_process(true)
    start_frame = get_frame()

func preProcess():
    pass

func _process(delta):
    preProcess()
    animate(delta)
    
func animate(delta):
    animation_counter += delta
    if animation_counter >= frame_delay:
        animation_counter = 0
        var frame = get_frame()

        if frame >= start_frame and frame < start_frame + max_frames - 1:
            set_frame(frame+1)
        else:
            set_frame(start_frame)
        
        if should_randomize_frame_delay:
            randomizeFrameDelay()

func randomizeFrameDelay():
    frame_delay = rand_range(0.1, 1.0)