extends "GameMover.gd"

# for backwards compatibility keep TextBox export var nextTextBoxPath if that is set (???)
# otherwise, try to set the textBox, and textBox->portrait.texture, textBox->text.bbtext to the set variables
export(NodePath) var nextTextBoxPath = NodePath("")
export(String, MULTILINE) var bbText = ""
export(Texture) var portrait

onready var textBoxContainer = get_node("NPC TextBox")
onready var textBox = get_node("NPC TextBox").get_node("TextBox")
onready var textBoxtext = get_node("NPC TextBox/TextBox/Text")
onready var textBoxportrait = get_node("NPC TextBox/TextBox/Portrait")


func _ready():
    set_process(true)
    set_physics_process(true)

    set_collision_mask_bit(1, true)

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

func _physics_process(delta):
    #._physics_process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    .processPhysics(delta)