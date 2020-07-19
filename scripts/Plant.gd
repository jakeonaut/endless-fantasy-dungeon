extends Spatial

# for backwards compatibility keep TextBox export var nextTextBoxPath if that is set (???)
# otherwise, try to set the textBox, and textBox->portrait.texture, textBox->text.bbtext to the set variables
export(NodePath) var nextTextBoxPath = NodePath("")
export(String, MULTILINE) var bbText = ""
export(Texture) var portrait

onready var textBoxContainer = get_node("Plant TextBox")
onready var textBox = get_node("Plant TextBox").get_node("TextBox")
onready var textBoxtext = get_node("Plant TextBox/TextBox/Text")
onready var textBoxportrait = get_node("Plant TextBox/TextBox/Portrait")


func _ready():
    if bbText != "" and textBoxContainer.bbText == "":
        textBoxContainer.bbText = bbText
    if portrait and not textBoxContainer.portrait:
        textBoxContainer.portrait = portrait
    if not nextTextBoxPath.is_empty() and textBoxContainer.nextTextBoxPath.is_empty():
        var nextTextBoxPathStr = "../"
        for i in range(nextTextBoxPath.get_name_count()):
            if i != 0:
                nextTextBoxPathStr += "/"
            nextTextBoxPathStr += nextTextBoxPath.get_name(i)
        textBoxContainer.nextTextBoxPath = NodePath(nextTextBoxPathStr)
    textBoxContainer.setVars()

func isActive():
    return visible

func activate():
    if global.activeInteractor == null:
        global.activeInteractor = textBox
        textBox.interact()

func passiveActivate(delta):
    pass

func stopPassiveActivate():
    pass