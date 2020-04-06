extends CanvasLayer

# for backwards compatibility keep TextBox export var nextTextBoxPath if that is set (???)
# otherwise, try to set the textBox, and textBox->portrait.texture, textBox->text.bbtext to the set variables
export(NodePath) var nextTextBoxPath = NodePath("")
export(String, MULTILINE) var bbText = ""
export(Texture) var portrait

onready var textBox = get_node("TextBox")
onready var textBoxtext = get_node("TextBox/Text")
onready var textBoxportrait = get_node("TextBox/Portrait")

var type = "textBoxContainer"

func _ready():
    self.setVars()

func setVars():
    if bbText != "":
        textBoxtext.bbcode_text = bbText
    if portrait:
        textBoxportrait.texture = portrait
    if not nextTextBoxPath.is_empty() and textBox.nextTextBoxPath.is_empty():
        var nextTextBoxPathStr = "../"
        for i in range(nextTextBoxPath.get_name_count()):
            if i != 0:
                nextTextBoxPathStr += "/"
            nextTextBoxPathStr += nextTextBoxPath.get_name(i)
        textBox.nextTextBoxPath = NodePath(nextTextBoxPathStr)

func InteractActivate():
    interact()
        
func interact():
    textBox.interact()