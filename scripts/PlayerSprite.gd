extends "Sprite.gd"

onready var parent = get_parent()

func _ready():
    set_process(true)

func _process(delta):
    if parent.linear_velocity.x != 0 or parent.linear_velocity.z != 0:
        frame_delay = 0.2
    elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") \
    or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
        frame_delay = 0.3
    else:
        frame_delay = 0.4
    animate(delta)

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

func setFloorGlitch():
    pass

func updateStartFrame(hframe, vframe):
    start_frame = (self.hframes * vframe) + hframe
    set_frame(start_frame)