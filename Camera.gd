extends Camera

onready var player = get_parent().get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	#look_at(player.translation, Vector3(0, 0, -1))
	pass
