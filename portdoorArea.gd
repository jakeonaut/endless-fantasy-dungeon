extends Area

export var connectedScene = "GenericScene.tscn"

onready var player = get_tree().get_root().get_node("level/Player")

var transitioning = false
var interactingWithPlayer = false
var canInteractWithPlayer = true

func _ready():
	set_process(true)
	
func _process(delta):
	# If we're already talking...
	if interactingWithPlayer:
		# Conversation finished naturally
		if global.activeInteractor == null:
			interactingWithPlayer = false
		# Player walked away, or was teleported/etc.
		elif not self.touchingPlayer():
			global.activeInteractor.abort()
			interactingWithPlayer = false
	
	elif touchingPlayer():
		var portdoor = get_parent()
			
		# initiate talking if we didn't just finish it!!!
		if portdoor.isLocked and canInteractWithPlayer:
			if global.activeInteractor == null:
				interactingWithPlayer = true
				canInteractWithPlayer = false
			get_parent().interact()
			
		# initiate room transition
		else:
			global.lastDoor = get_parent().name
			global.cameraRotation = player.get_node("TheCamera").rotation_degrees
			if not transitioning:
				# global transition scene
				transition.fade_to("res://" + connectedScene)
				transitioning = true
	
	else: # no longer touching player
		canInteractWithPlayer = true
		
		
func touchingPlayer():
	var areas = get_overlapping_areas()
	for area in areas:
		if area == player.get_node("InteractionArea"):
			return true
	return false