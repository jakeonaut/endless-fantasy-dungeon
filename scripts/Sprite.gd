extends Sprite3D

var animation_counter = 0
export var frame_delay = 0.4
# If true, this will override frame_delay after first frame change.
export var should_randomize_frame_delay = false
var start_frame = 0
var base_frame = start_frame
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

func updateBaseFrame(hframe, vframe):
    start_frame = (self.hframes * vframe) + hframe
    base_frame = start_frame
    set_frame(start_frame)

func faceLeft():
    var left_frame = base_frame + (self.hframes) + 2
    if start_frame != left_frame:
        start_frame = left_frame
        set_frame(start_frame)
func isFacingLeft(): # TODO(jaketrower): How can this interact with lunging and other varied animations ?
    var left_frame = base_frame + (self.hframes) + 2
    return start_frame == left_frame

func faceRight():
    var right_frame = base_frame + 2
    if start_frame != right_frame:
        start_frame = right_frame
        set_frame(start_frame)
func isFacingRight(): # TODO(jaketrower): How can this interact with lunging and other varied animations ?
    var right_frame = base_frame + 2
    return start_frame == right_frame

func faceUp():
    var up_frame = base_frame + (self.hframes)
    if start_frame != up_frame:
        start_frame = up_frame
        set_frame(start_frame)
func isFacingUp(): # TODO(jaketrower): How can this interact with lunging and other varied animations ?
    var up_frame = base_frame + (self.hframes)
    return start_frame == up_frame

func faceDown():
    var down_frame = base_frame
    if start_frame != down_frame:
        start_frame = down_frame
        set_frame(start_frame)
func isFacingDown(): # TODO(jaketrower): How can this interact with lunging and other varied animations ?
    var down_frame = base_frame
    return start_frame == down_frame