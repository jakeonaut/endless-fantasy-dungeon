extends Area

onready var playerArea = get_tree().get_root().get_node("level/Player/InteractionArea")

var hasActivated = false

func _ready():
	set_process(true)
	self.visible = false
	
func _process(delta):
	if touchingPlayer():
		passiveActivate(delta)
			
func touchingPlayer():
	var areas = get_overlapping_areas()
	for area in areas:
		if area == playerArea:
			return true
	return false
	
# TO BE OVERRIDDEN
func passiveActivate(delta):
	if not hasActivated:
		var npc = get_parent().get_node("NPC")
		npc.visible = false
		hasActivated = true