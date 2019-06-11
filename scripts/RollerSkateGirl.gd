extends "NPC.gd"

onready var player = get_tree().get_root().get_node("level/Player")
onready var mySprite = get_node("Sprite3D")
onready var skateSound = get_node("Sounds/SkateSound")

var pushTimer = 0
var pushTimeLimit = 10
var rotateTimer = 0
var rotateTimeLimit = 1
var walk_speed = 8
var is_skating = false
var skateVector = Vector3(0, 0, 0)

# @override
func passiveActivate(delta):
    if not is_skating and rotateTimer == 0:
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
            is_skating = true
            skateSound.play()
            pushTimer = 0
        

func stopPassiveActivate():
    if not is_skating: 
        pushTimer = 0

# @override
func processInputs(delta):
    if is_skating:
        hv = skateVector.normalized() * walk_speed

        rotateTimer += delta*22
        if rotateTimer >= rotateTimeLimit:
            rotateTimer = 0
            if mySprite.isFacingDown(): mySprite.faceLeft()
            elif mySprite.isFacingLeft(): mySprite.faceUp()
            elif mySprite.isFacingUp(): mySprite.faceRight()
            elif mySprite.isFacingRight(): mySprite.faceDown()

# @override
func postProcessInputs(delta):
    if is_skating \
    and linear_velocity.x < walk_speed/2 and linear_velocity.x > -walk_speed/2 \
    and linear_velocity.z < walk_speed/2 and linear_velocity.z > -walk_speed/2:
        is_skating = false
        mySprite.faceDown()
        pushTimer = 0
        rotateTimer = 0
        bumpSound.play()
        