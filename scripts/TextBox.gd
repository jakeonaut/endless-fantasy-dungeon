extends TextureRect

onready var text = get_node("Text")
onready var dialogSound = get_node("DialogSound")
onready var abortSound = get_node("AbortSound")
export(NodePath) var nextTextBoxPath = NodePath("")
onready var player = get_tree().get_root().get_node("level").get_node("Player")

var type = "textBox"

func _ready():
    self.hide()
    set_process_input(true)

func _input_event(camera, event, click_position, click_normal, shape_idx):
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.pressed:
        self.interact()

        
func InteractActivate():
    interact()
        
func interact():
    # dialogSound.isActive can be overridden
    if !visible and dialogSound.isActive():
        text.get_v_scroll().value = 0
        self.show()
        dialogSound.play()
        dialogSound.activateScript()
        if has_node("Event"):
            get_node("Event").activate()
        global.pauseGame = true
        global.pauseMoveInput = true
        if player.glitch_form != player.GlitchForm.FLOOR: player.on_ground = true
        player.vv = 0
        player.is_lunging = 0
    else:
        self.hide()
        global.pauseGame = false
        global.pauseMoveInput = false
        if !nextTextBoxPath.is_empty():
            var nextTextBox = get_node(nextTextBoxPath)
            if nextTextBox.type == "textBox":
                nextTextBox.interact()
            elif nextTextBox.type == "textBoxContainer":
                nextTextBox = nextTextBox.get_node("TextBox")
                nextTextBox.interact()
            global.activeInteractor = nextTextBox
        else:
            abortSound.play()
            abortSound.activateScript()
            global.activeInteractor = null
            
func abort():
    hide()
    abortSound.play()
    global.activeInteractor = null
    global.pauseGame = false
    global.pauseMoveInput = false