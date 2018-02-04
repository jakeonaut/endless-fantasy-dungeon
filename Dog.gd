extends Sprite3D

var speed = 5
var vel = Vector2()
var animationCounter = 0
var animationCountMax = 0.1

func _ready():
	set_process(true)
	
func _process(delta):
	animate(delta)
	
	if Input.is_key_pressed(KEY_RIGHT):
		vel = Vector2(speed, 0)
		animationCountMax = 0.1
	elif Input.is_key_pressed(KEY_LEFT):
		vel = Vector2(-speed, 0)
		animationCountMax = 0.1
	elif Input.is_key_pressed(KEY_UP):
		vel = Vector2(0, -speed)
		animationCountMax = 0.1
	elif Input.is_key_pressed(KEY_DOWN):
		vel = Vector2(0, speed)
		animationCountMax = 0.1
	else:
		vel = Vector2(0, 0)
		animationCountMax = 0.3
	
	translate(Vector3(vel.x, 0, vel.y) * delta)
	
func animate(delta):
	animationCounter += delta
	if animationCounter >= animationCountMax:
		animationCounter = 0
		var frame = get_frame()
		if frame == 0:
			set_frame(1)
		elif frame == 1:
			set_frame(0)