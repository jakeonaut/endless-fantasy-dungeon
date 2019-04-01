extends KinematicBody

onready var textBox = get_node("Object TextBox").get_node("TextBox")
onready var player = get_tree().get_root().get_node("level/Player")

func _ready():
    set_process_input(true)

func _input(event):
    if textBox.visible \
    and event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.pressed:
        activate()


func isActive():
    return visible

func activate():
    if global.activeInteractor == null:
        global.activeInteractor = textBox
        textBox.interact()
        
        match get_node("Sprite3D").frame:
            0: player.wearNormalClothes()
            1: player.wearMothCostume()
            # 2:
            3: player.wearBugCatcherCostume()
            4: player.wearClericCostume()
            # 5: 
            6: player.wearLuckyCatCostume()
            7: player.wearNightgown()
        # visible = false