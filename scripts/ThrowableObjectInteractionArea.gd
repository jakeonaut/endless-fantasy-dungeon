extends Area

var pickupCounter = 0
var pickupCounterMax = 10

func _ready():
	set_process(true)

func _process(delta):
	if global.activeThrowableObject == self and pickupCounter < pickupCounterMax:
		pickupCounter += 1


func InteractActivate():
	if not get_parent().isActive(): return

	# Should be able to talk while holding an object.
	if global.activeThrowableObject == null:
		# Pick up
		get_parent().interact()
		global.activeThrowableObject = self
		pickupCounter = 0
	elif pickupCounter >= pickupCounterMax and global.activeThrowableObject == self:
		# Throw!
		get_parent().interact()
		global.activeThrowableObject = null