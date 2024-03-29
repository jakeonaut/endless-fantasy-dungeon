extends Spatial

onready var camera_x = get_node("CameraX")
onready var true_camera = get_node("CameraX/Camera")
onready var close_camera = get_node("CameraX/CloseCamera")
onready var mid_camera = get_node("CameraX/MidCamera")
onready var toybox_camera = get_node("ToyboxCamera")
onready var player = get_node("..")
onready var player_sprite = get_node("../Sprite3D")

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
var highest_rotation_step = 3
var highest_mouse_rotation_step = 20
# steps up/down to target_rotation (also in radians)
var current_rotation = 0
var current_rotation_x = 0
var is_rotating = false
var is_rotating_slow = false
var is_rotating_x = false
var last_obstructing_objects = []
var lerp_timer = 0
var is_lerping = false
var source_lerp_index = 0
var target_lerp_index = 1
var lerp_targets = [0, 0]
var debug_print = false

# TODO(jaketrower): There are a lot of "same but for X" code repetition here
# TODO(jaketrower): can we somehow consolidate them into common methods?
func _ready():
    set_process_input(true)
    set_process(true)
    set_physics_process(true)

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

    lerp_targets = [close_camera, toybox_camera]
    
func _input(ev):
    if ev is InputEventMouseButton: # and ev.button_index == BUTTON_RIGHT:
        mouseDown = ev.is_pressed()
        startClickPos = ev.position
    elif ev is InputEventMouseMotion and not (global.pauseMoveInput or global.pauseGame):
        if mouseDown:
            mouseDiffX = startClickPos.x - ev.position.x
            mouseDiffY = startClickPos.y - ev.position.y
            startClickPos = ev.position

func _process(delta):
    if is_rotating and debug_print: 
        print("current_rotation: " + str(current_rotation) + ", " + str(rotation_degrees.y))

    var curr_step_y = curr_step.y
    if is_rotating_slow:
        curr_step_y = curr_step_y / 2
    if target_rotation > current_rotation:
        current_rotation += curr_step_y*delta
        rotate_y(curr_step_y * delta)
        player_sprite.fixSpriteFacing()
        if current_rotation > target_rotation:
            self.tryNormalizeCurrent()
    elif target_rotation < current_rotation:
        current_rotation -= curr_step_y*delta
        rotate_y(-curr_step_y * delta)
        player_sprite.fixSpriteFacing()
        if current_rotation < target_rotation:
            self.tryNormalizeCurrent()
    else:
        self.tryNormalizeCurrent()

    var curr_step_x = curr_step.x
    if target_rotation_x > current_rotation_x:
        current_rotation_x += curr_step_x*delta
        camera_x.rotate_x(curr_step_x * delta)
        if current_rotation_x > target_rotation_x:
            self.tryNormalizeCurrentX()
    elif target_rotation_x < current_rotation_x:
        current_rotation_x -= curr_step_x*delta
        camera_x.rotate_x(-curr_step_x * delta)
        if current_rotation_x < target_rotation_x:
            self.tryNormalizeCurrentX()
    else:
        self.tryNormalizeCurrentX()

    if not is_rotating:
        # if curr_step.y > 3.5:
        curr_step.y = 4
            
    self.processMouseInput(delta)

func processMouseInput(delta):
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

func focusForward(facing):
    # STILL DON'T REALLY KNOW WHAT I'M DOING HERE
    debug_print = true
    print(facing.normalized())
    var target_degrees = fposmod(rad2deg(Vector3(0, 0, -1).normalized().angle_to(facing.normalized())), 360)
    print("!! niotice me naoto")
    print(target_degrees)
    self.rotateTo(target_degrees)

    # rotate right
    # var rot_deg = fposmod(rotation_degrees.y, 360)
    # self.rotateTo(((int(rot_deg + 16)/90) + 1) * 90)

    # # rotate left
    # var rot_deg = fposmod(rotation_degrees.y-16, 360)
    # # don't ask me why.
    # if (int(rot_deg)/90)*90 == 270 and rotation_degrees.y >= 0:
    #     self.rotateTo(-90)
    # else:
    #     self.rotateTo((int(rot_deg)/90)*90)


const PROJECTION_PERSPECTIVE = 0
const PROJECTION_ORTHOGONAL = 1
func changeToPerspective():
    true_camera.set_projection(PROJECTION_PERSPECTIVE)

func changeToIsometric():
    true_camera.set_projection(PROJECTION_ORTHOGONAL)

func toggleNext():
    if true_camera.get_projection() == PROJECTION_PERSPECTIVE:
        true_camera.set_projection(PROJECTION_ORTHOGONAL)
    else:
        true_camera.set_projection(PROJECTION_PERSPECTIVE)
    # if not is_lerping:
    #     lerp_timer = 0
    #     is_lerping = true

func isToyboxView():
    return source_lerp_index == 1

func _physics_process(delta):
    if is_lerping:
        lerp_timer += delta*2
        var source_transform = lerp_targets[source_lerp_index].global_transform
        var target_transform = lerp_targets[target_lerp_index].global_transform
        true_camera.global_transform = source_transform.interpolate_with(
            target_transform, lerp_timer)
        var dist = true_camera.global_transform.origin.distance_to(target_transform.origin)
        if dist < delta:
            is_lerping = false
            source_lerp_index += 1 # nodelta
            if source_lerp_index >= lerp_targets.size(): 
                source_lerp_index = 0
            target_lerp_index += 1 # nodelta
            if target_lerp_index >= lerp_targets.size():
                target_lerp_index = 0

    var space_state = get_world().get_direct_space_state()
    var camera_pos = true_camera.global_transform.origin
    var player_pos = player.global_transform.origin
    var exclude = []

    # Not currently working with grid maps unfortunately
    # https://github.com/godotengine/godot/issues/14608
    # https://github.com/godotengine/godot/issues/27282
    # var collision_result = true
    # while collision_result:
    #     collision_result = space_state.intersect_ray(camera_pos, player_pos, exclude)
    #     if collision_result and !collision_result.collider == player:
    #         if (collision_result.collider is GridMap):
    #             var gridmap = collision_result.collider
    #             if not gridmap in exclude:
    #                 exclude.push_back(gridmap)
    #             var grid_pos = gridmap.world_to_map(collision_result.position)
    #             var cell_id = gridmap.get_cell_item(grid_pos.x, grid_pos.y, grid_pos.z)
    #             if cell_id == -1: 
    #                 #print(collision_result)
    #                 #print(grid_pos)
    #                 # while true: pass
    #                 break
                
    #             print(collision_result.position)
    #             print(grid_pos)
    #             print(cell_id)
    #             # var bake_mesh_rid = gridmap.get_bake_mesh_instance(cell_id)
    #             # exclude.push_back(bake_mesh_rid)
    #             print(exclude)

    #             gridmap.set_cell_item(grid_pos.x, grid_pos.y, grid_pos.z, GridMap.INVALID_CELL_ITEM)
    #             # while true:
    #             #     pass
                
    #         else:
    #             exclude.push_back(collision_result.collider)
    #     else:
    #         break # No more collisions/collided with player
        
    # last_obstructing_objects.show()
    # for obj in last_obstructing_objects:
    #     obj.show()

    # # exclude.hide()
    # for obj in exclude:
    #     obj.hide()

    last_obstructing_objects = exclude

    
func rotateTo(target_degrees, immediate=false, is_slow=false):
    real_rotation_target = target_degrees
    target_rotation = deg2rad(target_degrees)
    is_rotating = true
    is_rotating_slow = is_slow

    if immediate:
        rotation_degrees.y = real_rotation_target
        is_rotating = false
        self.normalizeTarget()
        current_rotation = target_rotation

func rotateXTo(target_degrees, immediate=false, is_slow=false):
    real_rotation_target_x = target_degrees
    target_rotation_x = deg2rad(target_degrees)
    is_rotating_x = true
    is_rotating_slow = is_slow

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
    
func setRotationMatX(rotationMatX):
    camera_x.rotation_degrees = rotationMatX
    real_rotation_target_x = camera_x.rotation_degrees.x
    target_rotation_x = deg2rad(real_rotation_target_x)
    current_rotation_x = target_rotation_x
            
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

func rotate_right_90deg():
    # i.e. if angle is currently at 0, move up to 4
    # then int divide by 90 (results in 0)
    # then add 1 (results in 1)
    # then multiply 90 (results in 90)
    # 0 -> 0 -> 4 -> 0 -> 1 -> 90
    # i.e. 10 -> 10 -> 14 -> 0 -> 1 -> 90
    # i.e. 90 -> 90 -> 94 -> 1 -> 2 -> 180
    # i.e. -90 -> 270 -> 274 -> 3 -> 4 -> 360
    if debug_print: print("rotation_degrees: " + str(rotation_degrees.y))
    var rot_deg = fposmod(rotation_degrees.y, 360)
    if debug_print: print("normalized: " + str(rot_deg))
    if debug_print: print("is rotating?: " + str(is_rotating))
    self.rotateTo(((int(rot_deg + 16)/90) + 1) * 90)
    if debug_print: print("rotate to: " + str(((int(rot_deg + 16)/90) + 1) * 90))

func rotate_left_90deg():
    # i.e. if angle is currently at 180, move down to 176
    # then int divide by 90 (results in 1)
    # then multiply 90 (results in 90)
    # 180 -> 176 -> 1 -> 90
    # i.e. 150 -> 146 -> 1 -> 90
    # i.e. 90 -> 86 -> 0 -> 0
    # i.e. 0 -> -4 -> 
    var rot_deg = fposmod(rotation_degrees.y-16, 360)
    # don't ask me why.
    if (int(rot_deg)/90)*90 == 270 and rotation_degrees.y >= 0:
        self.rotateTo(-90)
    else:
        self.rotateTo((int(rot_deg)/90)*90)

# TODO(jaketrower):
func rotate_up(step=5):
    if self.isToyboxView(): return

    if not is_rotating_x:
        if self.gateKeepUpCondition_(target_rotation_x):
            target_rotation_x -= deg2rad(rstep)
            real_rotation_target_x = camera_x.rotation_degrees.x - rstep
            is_rotating_x = true
            
func gateKeepUpCondition_(rx):
    if rx > 0: return rad2deg(rx) > 270
    if rx < 0: return rad2deg(rx) < -90

# TODO(jaketrower):
func rotate_down(step=5):
    if self.isToyboxView(): return
    if not is_rotating_x:
        if self.gateKeepDownCondition_(target_rotation_x):
            target_rotation_x += deg2rad(rstep)
            real_rotation_target_x = camera_x.rotation_degrees.x + rstep
            is_rotating_x = true
            
func gateKeepDownCondition_(rx):
    return (rad2deg(rx) < 360 and rad2deg(rx) >= 270) or (rad2deg(rx) > 0 and rad2deg(rx) <= 90)
    
func tryNormalizeCurrent():
    if is_rotating and debug_print: print("current_rotation: " + str(current_rotation))
    if is_rotating and abs(target_rotation - current_rotation) < 1:
        self.normalizeTarget()
        current_rotation = target_rotation
        debug_print = false
    is_rotating = false
    is_rotating_slow = false
    
func normalizeTarget():
    while target_rotation < 0:
        target_rotation += deg2rad(360)
    while target_rotation >= deg2rad(360):
        target_rotation -= deg2rad(360)
    
    rotation_degrees.y = real_rotation_target
    if debug_print: print("set rotation_degrees.y to: " + str(rotation_degrees.y))
        
    var rotation = rad2deg(target_rotation)
    rotation = int(round(rotation/rstep))*rstep
    target_rotation = deg2rad(rotation)
    if debug_print: print("set target_rotation to: " + str(target_rotation))

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