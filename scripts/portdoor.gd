extends Sprite3D

var topLevelDir = "levels"
export var midLevelDir = ""
export var connectedScene = "GenericScene.tscn"
export var isLocked = false

onready var area = get_node("Area")
onready var enterSound = get_node("EnterSound")
onready var player = get_tree().get_root().get_node("level/Player")
onready var landingPad = get_node("landing-pad")
onready var textBox = get_node("portdoorTextBox").get_node("TextBox")

var canInteractWithPlayer = true

var transitioning = false

func _ready():
    add_to_group("doors")

    area.hide()
    landingPad.hide()
    
    parseConnectedScene()
    
    if isLocked:
        get_node("PolyTriangle").texture = load("res://assets/npcs/tootorialgrey.png")
        get_node("PolyTriangle").step = 1

func unlock():
    isLocked = false
    get_node("PolyTriangle").texture = load("res://assets/npcs/tootorial0000.png")
    get_node("PolyTriangle").step = 2

func parseConnectedScene():
    # strip ".tscn" from connectedScene if it exists, and then add ".tscn"
    # allows user to just refer to level by name and not specify ".tscn".
    # but allows backwards compatibility too :)
    var index = connectedScene.find_last(".tscn")
    if (index > 0):
        connectedScene.erase(index, 5)
    connectedScene += ".tscn"

    # If connected scene begins with topLevelDir "levels/"
    # assume resource is fully populated 
    if not connectedScene.begins_with(topLevelDir + "/"):
        # otherwise, append topLevelDir and midLevelDir to full resource path
        var dir = topLevelDir
        if midLevelDir != "":
            dir += "/" + midLevelDir
        connectedScene = dir + "/" + connectedScene

func isActive():
    return visible

func passiveActivate():
    if canInteractWithPlayer:
        # initiate talking if we didn't just finish it!!!
        if isLocked:
            lockTalk()
        # initiate room transition
        else:
            enterDoor()

func stopPassiveActivate():
    canInteractWithPlayer = true

func lockTalk():    
    if global.activeInteractor == null:
        global.activeInteractor = textBox
        textBox.interact()
        canInteractWithPlayer = false

func enterDoor():
    global.memory["lastDoor"] = name
    if not transitioning:
        # global transition scene, see res://scripts/transition.gd
        transition.fade_to("res://" + connectedScene)
        transitioning = true
        # when entering a new level, res://scripts/levelScript.gd runs

func land():
    if not global.playerJustFell:
        enterSound.play()
    player.global_transform.origin = landingPad.global_transform.origin
    player.getCamera().rotateTo(180 + self.rotation_degrees.y, true)