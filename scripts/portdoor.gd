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

var interactingWithPlayer = false
var canInteractWithPlayer = true
var transitioning = false

func _ready():
    set_process(true)
    add_to_group("doors")

    area.hide()
    landingPad.hide()
    
    parseConnectedScene()

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

func _process(delta):
    # If we're already talking...
    if interactingWithPlayer:
        # Conversation finished naturally
        if global.activeInteractor == null:
            interactingWithPlayer = false
        # Player walked away, or was teleported/etc.
        #elif not self.touchingPlayer():
        #    global.activeInteractor.abort()
        #    interactingWithPlayer = false 
    else: # no longer touching player
        canInteractWithPlayer = true

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

func lockTalk():    
    if global.activeInteractor == null:
        global.activeInteractor = textBox
        textBox.interact()
        interactingWithPlayer = true
        canInteractWithPlayer = false
    else:
        global.activeInteractor.interact()

func enterDoor():
    global.lastDoor = name
    global.cameraRotation = player.getCamera().rotation_degrees
    global.activeInteractor = null
    if not transitioning:
        # global transition scene, see res://scripts/transition.gd
        transition.fade_to("res://" + connectedScene)
        transitioning = true
        # when entering a new level, res://scripts/levelScript.gd runs

func land():
    enterSound.play()
    player.global_transform.origin = landingPad.global_transform.origin