extends AudioStreamPlayer

func _ready():
	pass

func activateScript():
	var goddess = get_node("../../..")
	goddess.visible = false
	var collisionShape = goddess.get_node("CollisionShape")
	collisionShape.disabled = true