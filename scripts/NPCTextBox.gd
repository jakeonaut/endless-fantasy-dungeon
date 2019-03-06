extends TextureRect

onready var text = get_node("Text")
onready var dialogSound = get_node("DialogSound")
onready var abortSound = get_node("AbortSound")
export var nextTextboxPath = NodePath("")

var bufferTimer = 0
var bufferTimeLimit = 10

func _ready():
    self.hide()
        
func interact():
    if !self.visible:
        text.get_v_scroll().value = 0
        self.show()
        dialogSound.play()
        dialogSound.activateScript()
        var event = get_node("Event")
        if event:
            event.activate()
        global.pauseMoveInput = true
    else:
        self.hide()
        global.pauseMoveInput = false
        if !nextTextboxPath.is_empty():
            var nextTextbox = get_node(nextTextboxPath)
            nextTextbox.interact()
            global.activeInteractor = nextTextbox
        else:
            abortSound.play()
            abortSound.activateScript()
            global.activeInteractor = null
            
func abort():
    self.hide()
    abortSound.play()
    global.activeInteractor = null
    global.pauseMoveInput = false