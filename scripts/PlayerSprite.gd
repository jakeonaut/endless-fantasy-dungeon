extends "Sprite.gd"

onready var parent = get_parent()

func _ready():
    set_process(true)

func preProcess():
    .preProcess() # super

    # an object in motion...
    if parent.linear_velocity.x > 0.001 or parent.linear_velocity.x < -0.001 \
       or parent.linear_velocity.z > 0.001 or parent.linear_velocity.z < -0.001:
        frame_delay = 0.1
    # TODO (need to pull this from PlayerGameMover, if glitch_form == GlitchForm.FEATHER and not on_ground)
    elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") \
         or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
        frame_delay = 0.2
    else:
        frame_delay = 0.4

func setNormalClothes():
    updateStartFrame(0, 0)
func setMothCostume():
    updateStartFrame(0, 6)
func setBugCatcherCostume():
    updateStartFrame(0, 2)
func setClericCostume():
    updateStartFrame(4, 0)
func setLuckyCatCostume():
    updateStartFrame(0, 4)
func setNightgown():
    updateStartFrame(4, 2)

# @override
func animate(delta):
    animation_counter += delta
    if animation_counter >= frame_delay:
        animation_counter = 0
        var frame = get_frame()

        if self.isFacingRight() or self.isFacingLeft():
            if frame >= start_frame and frame < start_frame + max_frames - 1:
                set_frame(frame+1)
            else:
                set_frame(start_frame)
        elif self.isFacingDown() or self.isFacingUp():
            set_frame(start_frame)
            self.flip_h = not self.flip_h
        else:
            set_frame(start_frame)
        
        if should_randomize_frame_delay:
            randomizeFrameDelay()

# @override
func faceLeft():
    faceRight()
    self.flip_h = true
# @override
func isFacingLeft():
    var right_frame = base_frame + 2
    return start_frame == right_frame and self.flip_h

# @override
func faceRight():
    var right_frame = base_frame + 2
    if start_frame != right_frame:
        start_frame = right_frame
        set_frame(start_frame)
    self.flip_h = false
# @override
func isFacingRight():
    var right_frame = base_frame + 2
    return start_frame == right_frame and not self.flip_h