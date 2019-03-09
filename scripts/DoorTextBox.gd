extends TextureRect

onready var text = get_node("Text")
onready var dialogSound = get_node("DialogSound")
onready var abortSound = get_node("AbortSound")
export var nextTextboxPath = NodePath("")

func _ready():
	self.hide()
	set_process_input(true)

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		self.interact()
		
func interact():
	if !self.visible:
		text.get_v_scroll().value = 0
		self.show()
		dialogSound.play()
		if has_node("Event"):
            get_node("Event").activate()
	else:
		self.hide()
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