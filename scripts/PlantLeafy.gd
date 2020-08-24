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

var plantTopScale = 1
var plantBaseScale = 1
var growOrShrink = 0
onready var mesh = get_node("Mesh")
onready var plantTop = get_node("Mesh/plantTop")
onready var plantBase = get_node("Mesh/plantBase")


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

func _process(delta):
    # calculate it
    if growOrShrink == 0:
        plantBaseScale = plantBaseScale - (delta*.25)
        plantTopScale = plantTopScale + (delta*.25)
        if plantTopScale >= 1.05:
            growOrShrink = 1
    elif growOrShrink >= 3:
        plantBaseScale = plantBaseScale + (delta*.25)
        plantTopScale = plantTopScale - (delta*.25)
        if plantTopScale <= 0.8:
            growOrShrink = 0
    elif growOrShrink >= 1:
        growOrShrink += (delta*22)
    
    # now set it
    plantTop.scale = Vector3(plantTopScale, 1, plantTopScale)
    plantBase.scale = Vector3(plantBaseScale, 1, plantBaseScale)
    mesh.scale = Vector3(0.7, plantTopScale*.75, 0.7)

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