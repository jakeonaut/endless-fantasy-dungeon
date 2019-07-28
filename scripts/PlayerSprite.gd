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