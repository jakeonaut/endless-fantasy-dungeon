extends "Sprite.gd"

onready var parent = get_parent()
var base_frame = start_frame

func _ready():
    set_process(true)

func preProcess():
    .preProcess() # super

    # an object in motion...
    if parent.linear_velocity.x > 0.001 or parent.linear_velocity.x < -0.001 \
       or parent.linear_velocity.z > 0.001 or parent.linear_velocity.z < -0.001:
        frame_delay = 0.1
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

func faceLeft():
    var left_frame = base_frame + (self.hframes) + 2
    if start_frame != left_frame:
        start_frame = left_frame
        set_frame(start_frame)
func faceRight():
    var right_frame = base_frame + 2
    if start_frame != right_frame:
        start_frame = right_frame
        set_frame(start_frame)
func faceUp():
    var up_frame = base_frame + (self.hframes)
    if start_frame != up_frame:
        start_frame = up_frame
        set_frame(start_frame)
func faceDown():
    var down_frame = base_frame
    if start_frame != down_frame:
        start_frame = down_frame
        set_frame(start_frame)
func isFacingDown(): return start_frame == base_frame

func setFloorGlitch():
    pass

func updateStartFrame(hframe, vframe):
    start_frame = (self.hframes * vframe) + hframe
    base_frame = start_frame
    set_frame(start_frame)