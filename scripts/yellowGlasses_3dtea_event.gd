extends AudioStreamPlayer


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func activateScript():
	var playerCamera = get_node("../../../../Player/TheCamera")
	playerCamera.forceRotation(360, 8)