extends TextureRect

onready var portrait = get_node("Portrait")
export var portraitTexture = preload("res://assets/mini.png")

onready var text = get_node("Text")
export var bbcodeText = "yo what up\nhey mu dude\n???????? so why???"

func _ready():
	portrait.texture = portraitTexture
	text.clear()
	text.append_bbcode(bbcodeText)
