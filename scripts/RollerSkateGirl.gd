extends "NPC.gd"

onready var player = get_tree().get_root().get_node("level/Player")
onready var smallInteractionArea = get_node("SmallInteractionArea")

var pushTimer = 0
var pushTimeLimit = 5

# @override
func _physics_process(delta):
    # NPC.gd super method already called
    self.is_touching_speed_boost = smallInteractionArea.is_touching_speed_boost
    self.speed_boost_angle = smallInteractionArea.speed_boost_angle
    self.speed_boost_origin = smallInteractionArea.speed_boost_origin

# @override
func passiveActivate(delta):
    if not is_skating and skateRotateTimer == 0:
        # have to calculate player's dir and modulo to nearest 90 degree angle
        # also player.linear_velocity.x < walk_speed / 2 and player.linear_velocity.x > -walk_speed/2
        # ALSO player should have their x/z coordinates inline with the 90 degree modulo above
        # offset by NPC position
        var px = player.global_transform.origin.x
        var pz = player.global_transform.origin.z
        var sx = self.global_transform.origin.x
        var sz = self.global_transform.origin.z
        if abs(px - sx) > abs(pz - sz) and px > sx and player.dir.x < 0: # player pushing west
            skateVector = Vector3(-1, 0, 0)
            pushTimer += delta*22
        elif abs(px - sx) > abs(pz - sz) and px < sx and player.dir.x > 0: # player pushing east
            skateVector = Vector3(1, 0, 0)
            pushTimer += delta*22
        elif abs(px - sx) < abs(pz - sz) and pz > sz and player.dir.z < 0: # player pushing north
            skateVector = Vector3(0, 0, -1)
            pushTimer += delta*22
        elif abs(px - sx) < abs(pz - sz) and pz < sz and player.dir.z > 0: # player pushing south
            skateVector = Vector3(0, 0, 1)
            pushTimer += delta*22
        else:
            pushTimer = 0

        if pushTimer >= pushTimeLimit:
            pushTimer = 0
            self.tryStartSkate()

func stopPassiveActivate():
    if not is_skating: 
        pushTimer = 0
        