extends Spatial

onready var camera_x = get_node("CameraX")

var mouseDown = false
var startClickPos = Vector2(0, 0)
var mouseDiffX = 0
var mouseDiffY = 0
# real rotation target is in degrees
var real_rotation_target = 0
var real_rotation_target_x = 0
# target rotation is in radians
var target_rotation = 0
var target_rotation_x = 0
var rstep = 5
var highest_rotation_step = 20
# steps up/down to target_rotation (also in radians)
var current_rotation = 0
var current_rotation_x = 0
var is_rotating = false
var is_rotating_x = false

# TODO(jaketrower): There are a lot of "same but for X" code repetition here
# TODO(jaketrower): can we somehow consolidate them into common methods?
func _ready():
    set_process_input(true)
    set_process(true)

    # grab current rotation from position of camera,
    # so future calculations will be accurate
    target_rotation = self.rotation.y
    real_rotation_target = self.rotation_degrees.y
    self.normalizeTarget()
    current_rotation = target_rotation
    # same but for X
    target_rotation_x = camera_x.rotation.x
    real_rotation_target_x = camera_x.rotation_degrees.x
    self.normalizeTargetX()
    current_rotation_x = target_rotation_x
    
func _input(ev):
    if global.pauseMoveInput:
        mouseDown = false
        return
        
    if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT:
        mouseDown = ev.is_pressed()
        startClickPos = ev.position
    elif ev is InputEventMouseMotion:
        if mouseDown:
            mouseDiffX = startClickPos.x - ev.position.x
            mouseDiffY = startClickPos.y - ev.position.y
            startClickPos = ev.position

func _process(delta):
    var step = 4
    
    if target_rotation > current_rotation:
        current_rotation += step*delta
        rotate_y(step * delta)
        if current_rotation > target_rotation:
            self.tryNormalizeCurrent()
    elif target_rotation < current_rotation:
        current_rotation -= step*delta
        rotate_y(-step * delta)
        if current_rotation < target_rotation:
            self.tryNormalizeCurrent()
    else:
        self.tryNormalizeCurrent()

    if target_rotation_x > current_rotation_x:
        current_rotation_x += step*delta
        camera_x.rotate_x(step * delta)
        if current_rotation_x > target_rotation_x:
            self.tryNormalizeCurrentX()
    elif target_rotation_x < current_rotation_x:
        current_rotation_x -= step*delta
        camera_x.rotate_x(-step * delta)
        if current_rotation_x < target_rotation_x:
            self.tryNormalizeCurrentX()
    else:
        self.tryNormalizeCurrentX()
            
    # NOW DO MOUSE???
    if mouseDiffX < -highest_rotation_step:
        mouseDiffX = -highest_rotation_step
    elif mouseDiffX > highest_rotation_step:
        mouseDiffX = highest_rotation_step
    rotate_y(mouseDiffX * delta)

    mouseDiffX = 0
    mouseDiffY = 0
    
func rotateTo(target_degrees):
    real_rotation_target = target_degrees
    target_rotation = deg2rad(target_degrees)
    is_rotating = true

func rotateXTo(target_degrees):
    real_rotation_target_x = target_degrees
    target_rotation_x = deg2rad(target_degrees)
    is_rotating_x = true
    
func forceRotation(degrees, step):
    target_rotation += deg2rad(degrees)
    real_rotation_target = rotation_degrees.y + degrees
    is_rotating = true
    
    # nudge it along
    target_rotation += step
    rotate_y(step)
    
func setRotationMat(rotationMat):
    rotation_degrees = rotationMat
    real_rotation_target = rotation_degrees.y
    target_rotation = deg2rad(real_rotation_target)
    current_rotation = target_rotation
    
            
func rotate_right():
    if not is_rotating:
        target_rotation -= deg2rad(rstep)
        real_rotation_target = rotation_degrees.y - rstep
        is_rotating = true
    
func rotate_left():
    if not is_rotating:
        target_rotation += deg2rad(rstep)
        real_rotation_target = rotation_degrees.y + rstep
        is_rotating = true

# TODO(jaketrower):
func rotate_up():
    if not is_rotating_x:
        if rad2deg(target_rotation_x) > 270:
            target_rotation_x -= deg2rad(rstep)
            real_rotation_target_x = camera_x.rotation_degrees.x - rstep
            is_rotating_x = true
        else:
            rotate_left()

# TODO(jaketrower):
func rotate_down():
    if not is_rotating_x:
        if (rad2deg(target_rotation_x) < 360 and rad2deg(target_rotation_x) >= 270) or \
           (rad2deg(target_rotation_x) > 0 and rad2deg(target_rotation_x) <= 90):
            target_rotation_x += deg2rad(rstep)
            real_rotation_target_x = camera_x.rotation_degrees.x + rstep
            is_rotating_x = true
        else:
            rotate_right()
    
func tryNormalizeCurrent():
    if is_rotating and abs(target_rotation - current_rotation) < 1:
        self.normalizeTarget()
        current_rotation = target_rotation
    is_rotating = false
    
func normalizeTarget():
    while target_rotation < 0:
        target_rotation += deg2rad(360)
    while target_rotation > deg2rad(360):
        target_rotation -= deg2rad(360)
        
    rotation_degrees.y = real_rotation_target
        
    var rotation = rad2deg(target_rotation)
    rotation = int(round(rotation/rstep))*rstep
    target_rotation = deg2rad(rotation)

func tryNormalizeCurrentX():
    if is_rotating_x and abs(target_rotation_x - current_rotation_x) < 1:
        self.normalizeTargetX()
        current_rotation_x = target_rotation_x
    is_rotating_x = false

func normalizeTargetX():
    while target_rotation_x < 0:
        target_rotation_x += deg2rad(360)
    while target_rotation_x > deg2rad(360):
        target_rotation_x -= deg2rad(360)
        
    camera_x.rotation_degrees.x = real_rotation_target_x
        
    var rotation_x = rad2deg(target_rotation_x)
    rotation_x = int(round(rotation_x/rstep))*rstep
    target_rotation_x = deg2rad(rotation_x)