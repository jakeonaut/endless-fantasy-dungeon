extends TextureRect

onready var text = get_node("Text")
onready var dialogSound = get_node("DialogSound")
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
	if !self.visible and !global.isTalking:
		text.get_v_scroll().value = 0
		self.show()
		dialogSound.play()
		global.isTalking = true
	elif !self.isDone():
		self.next()
	else:
		self.hide()
		global.isTalking = false
		if !nextTextboxPath.is_empty():
			var nextTextbox = get_node(nextTextboxPath)
			nextTextbox.interact()
		else:
			dialogSound.play()
		
func isDone():
	var vscroll = text.get_v_scroll()
	if vscroll.value + vscroll.page < vscroll.max_value:
		return false
	return true
	
func next():
	var vscroll = text.get_v_scroll()
	vscroll.value += vscroll.page