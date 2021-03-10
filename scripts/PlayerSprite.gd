extends "Sprite.gd"

onready var parent = get_parent()

func _ready():
    set_process(true)

func preProcess():
    .preProcess() # super

    # an object in motion...
    if parent.linear_velocity.x > 0.001 or parent.linear_velocity.x < -0.001 \
       or parent.linear_velocity.z > 0.001 or parent.linear_velocity.z < -0.001 \
       or parent.broom_state > 0:
        frame_delay = 0.1
    # TODO (need to pull this from PlayerGameMover, if glitch_form == GlitchForm.FEATHER and not on_ground)
    elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") \
         or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
        frame_delay = 0.2
    else:
        frame_delay = 0.4

func setNormalClothes():
    updateBaseFrame(0, 0)
func setMothCostume():
    updateBaseFrame(0, 6)
func setBugCatcherCostume():
    updateBaseFrame(0, 2)
func setClericCostume():
    updateBaseFrame(4, 0)
func setLuckyCatCostume():
    updateBaseFrame(0, 4)
func setNightgown():
    updateBaseFrame(4, 2)

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
    var right_lunge_frame = base_frame + (self.hframes) + 3
    return (start_frame == right_frame or start_frame == right_lunge_frame) and self.flip_h

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
    var right_lunge_frame = base_frame + (self.hframes) + 3
    return (start_frame == right_frame or start_frame == right_lunge_frame) and not self.flip_h

# @override
func isFacingUp():
    var up_lunge_frame = base_frame + (self.hframes) + 2
    return .isFacingUp() or start_frame == up_lunge_frame

# @override
func isFacingDown():
    var down_lunge_frame = base_frame + (self.hframes) + 1
    return .isFacingDown() or start_frame == down_lunge_frame

func setLungeSprite(val):
    # TODO(jaketrower): This should be set by facing, not sprite position
    # so as to fix double jump spin error
    if val:
        if isFacingDown():
            start_frame = base_frame + (self.hframes) + 1
        elif isFacingUp():
            start_frame = base_frame + (self.hframes) + 2
        elif isFacingRight():
            start_frame = base_frame + (self.hframes) + 3
            self.flip_h = false
        elif isFacingLeft():
            start_frame = base_frame + (self.hframes) + 3
            self.flip_h = true
        set_frame(start_frame)
        max_frames = 1
    else:
        if isFacingDown():
            faceDown()
        if isFacingUp():
            faceUp()
        if isFacingRight():
            faceRight()
        if isFacingLeft():
            faceLeft()
        max_frames = 2