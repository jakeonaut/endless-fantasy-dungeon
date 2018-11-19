extends Area

var interactingWithPlayer = false
var pickupCounter = 0
var pickupCounterMax = 10

func _ready():
	set_process(true)

func _process(delta):
	if interactingWithPlayer and pickupCounter < pickupCounterMax:
		pickupCounter += 1


func InteractActivate():
	if not get_parent().isActive(): return

	# Should be able to talk while holding an object.
	if global.activeThrowableObject == null:
		get_parent().interact()
		if not interactingWithPlayer:
			interactingWithPlayer = true
		global.activeThrowableObject = self
		pickupCounter = 0
	elif pickupCounter >= pickupCounterMax and interactingWithPlayer and \
			global.activeThrowableObject == self:
		get_parent().interact()