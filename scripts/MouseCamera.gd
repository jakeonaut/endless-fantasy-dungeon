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
var curr_step = Vector2(4, 4)
var highest_rotation_step = 4
var highest_mouse_rotation_step = 20
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
    if ev is InputEventMouseButton and ev.button_index == BUTTON_RIGHT:
        mouseDown = ev.is_pressed()
        startClickPos = ev.position
    elif ev is InputEventMouseMotion and not global.pauseMoveInput:
        if mouseDown:
            mouseDiffX = startClickPos.x - ev.position.x
            mouseDiffY = startClickPos.y - ev.position.y
            startClickPos = ev.position

func _process(delta):
    if target_rotation > current_rotation:
        current_rotation += curr_step.y*delta
        rotate_y(curr_step.y * delta)
        if current_rotation > target_rotation:
            self.tryNormalizeCurrent()
    elif target_rotation < current_rotation:
        current_rotation -= curr_step.y*delta
        rotate_y(-curr_step.y * delta)
        if current_rotation < target_rotation:
            self.tryNormalizeCurrent()
    else:
        self.tryNormalizeCurrent()

    if target_rotation_x > current_rotation_x:
        current_rotation_x += curr_step.x*delta
        camera_x.rotate_x(curr_step.x * delta)
        if current_rotation_x > target_rotation_x:
            self.tryNormalizeCurrentX()
    elif target_rotation_x < current_rotation_x:
        current_rotation_x -= curr_step.x*delta
        camera_x.rotate_x(-curr_step.x * delta)
        if current_rotation_x < target_rotation_x:
            self.tryNormalizeCurrentX()
    else:
        self.tryNormalizeCurrentX()

    if not is_rotating:
        # if curr_step.y > 3.5:
        curr_step.y = 4
            
        
    # NOW DO MOUSE???
    if mouseDiffX < -highest_mouse_rotation_step:
        mouseDiffX = -highest_mouse_rotation_step
    elif mouseDiffX > highest_mouse_rotation_step:
        mouseDiffX = highest_mouse_rotation_step
    if mouseDiffY < -highest_mouse_rotation_step:
        mouseDiffY = -highest_mouse_rotation_step
    elif mouseDiffY > highest_mouse_rotation_step:
        mouseDiffY = highest_mouse_rotation_step
    rotate_y(mouseDiffX * delta)
    if (mouseDiffY > 0 and not self.gateKeepDownCondition_(camera_x.rotation.x)) or \
       (mouseDiffY < 0 and not self.gateKeepUpCondition_(camera_x.rotation.x)):
        camera_x.rotate_x(mouseDiffY * delta)
    mouseDiffX = 0
    mouseDiffY = 0
    
func rotateTo(target_degrees, immediate=false):
    real_rotation_target = target_degrees
    target_rotation = deg2rad(target_degrees)
    is_rotating = true

    if immediate:
        rotation_degrees.y = real_rotation_target
        is_rotating = false
        self.normalizeTarget()
        current_rotation = target_rotation

func rotateXTo(target_degrees, immediate=false):
    real_rotation_target_x = target_degrees
    target_rotation_x = deg2rad(target_degrees)
    is_rotating_x = true

    if immediate:
        camera_x.rotation_degrees.x = real_rotation_target_x
        is_rotating_x = false
        self.normalizeTargetX()
        current_rotation_x = target_rotation_x
    
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
    
            
func rotate_right(step=4):
    self.curr_step.y = step
    if curr_step.y >= highest_rotation_step:
        curr_step.y = highest_rotation_step

    if not is_rotating:
        target_rotation += deg2rad(step)
        real_rotation_target = rotation_degrees.y + step
        is_rotating = true
    
func rotate_left(step=4):
    self.curr_step.y = step
    if curr_step.y >= highest_rotation_step:
        curr_step.y = highest_rotation_step

    if not is_rotating:
        target_rotation -= deg2rad(step)
        real_rotation_target = rotation_degrees.y - step
        is_rotating = true

# TODO(jaketrower):
func rotate_up():
    if not is_rotating_x:
        if self.gateKeepUpCondition_(target_rotation_x):
            target_rotation_x -= deg2rad(rstep)
            real_rotation_target_x = camera_x.rotation_degrees.x - rstep
            is_rotating_x = true
            
func gateKeepUpCondition_(rx):
    if rx > 0: return rad2deg(rx) > 270
    if rx < 0: return rad2deg(rx) < -90

# TODO(jaketrower):
func rotate_down():
    if not is_rotating_x:
        if self.gateKeepDownCondition_(target_rotation_x):
            target_rotation_x += deg2rad(rstep)
            real_rotation_target_x = camera_x.rotation_degrees.x + rstep
            is_rotating_x = true
            
func gateKeepDownCondition_(rx):
    return (rad2deg(rx) < 360 and rad2deg(rx) >= 270) or (rad2deg(rx) > 0 and rad2deg(rx) <= 90)
    
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