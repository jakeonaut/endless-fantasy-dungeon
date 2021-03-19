extends Sprite3D

var animation_counter = 0
export var frame_delay = 0.4
# If true, this will override frame_delay after first frame change.
export var should_randomize_frame_delay = false
var start_frame = 0
var base_frame = start_frame
export var max_frames = 2

var facing = Vector2(0, 1)
var is_rotating = false

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
    facing = Vector2(-1, 0)
func isFacingLeft(): # TODO(jaketrower): How can this interact with lunging and other varied animations ?
    # var left_frame = base_frame + (self.hframes) + 2
    # return start_frame == left_frame
    return facing.x == -1 and facing.y == 0

func faceRight():
    var right_frame = base_frame + 2
    if start_frame != right_frame:
        start_frame = right_frame
        set_frame(start_frame)
    facing = Vector2(1, 0)
func isFacingRight(): # TODO(jaketrower): How can this interact with lunging and other varied animations ?
    # var right_frame = base_frame + 2
    # return start_frame == right_frame
    return facing.x == 1 and facing.y == 0

func faceUp():
    var up_frame = base_frame + (self.hframes)
    if start_frame != up_frame:
        start_frame = up_frame
        set_frame(start_frame)
    facing = Vector2(0, -1)

    
func isFacingUp(): # TODO(jaketrower): How can this interact with lunging and other varied animations ?
    # var up_frame = base_frame + (self.hframes)
    # return start_frame == up_frame
    return facing.x == 0 and facing.y == -1

func faceDown():
    var down_frame = base_frame
    if start_frame != down_frame:
        start_frame = down_frame
        set_frame(start_frame)
    facing = Vector2(0, 1)
func isFacingDown(): # TODO(jaketrower): How can this interact with lunging and other varied animations ?
    # var down_frame = base_frame
    # return start_frame == down_frame
    return facing.x == 0 and facing.y == 1

func fixSpriteFacing():
    if not is_rotating:
        # by default, just face down. Player will have more sophisticated based on facing var and camera
        faceDown()

func setRotating(val):
    is_rotating = val

func setFlipRotating(val):
    # is_flip_rotating = val
    pass