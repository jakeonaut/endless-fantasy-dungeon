extends Spatial

onready var levelRoot = get_tree().get_root().get_node("level")
onready var spitSound = get_node("Sounds/SpitSound")
onready var activeMeshInstance = self.get_node("MeshInstance")
onready var inactiveMeshInstance = self.get_node("InactiveMeshInstance")

# TODO(jaketrower): doing stuff like this... is dangerous 
# see: https://www.reddit.com/r/godot/comments/ait6y8/preloading_in_godot_31_vs_30/
const coin_resource = preload("res://levels/Casino/coin.tscn")
export(int) var num_coins = 5

var num_coins_spawned = 0
var coinSpawnTimer = 0
var coinSpawnTimeLimit = 5
var can_activate = true

func _ready():
    set_process(true)
    if num_coins == 5:
        num_coins = int(rand_range(1.0, 8.0))
    # stop the mid game freeze
    inactiveMeshInstance.visible = true

func _process(delta):
    #._process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    if num_coins_spawned >= 1 and num_coins_spawned < num_coins:
        coinSpawnTimer += (delta*22)
        if coinSpawnTimer > coinSpawnTimeLimit:
            self.spawnCoin()
    elif num_coins_spawned >= 1 and activeMeshInstance.visible:
        activeMeshInstance.visible = false
        inactiveMeshInstance.visible = true
    elif activeMeshInstance.visible:
        inactiveMeshInstance.visible = false
func spawnCoin():
    var newCoin = coin_resource.instance()
    # TODO(jaketrower): This node container is an ASSUMPTION!!!
    levelRoot.get_node("coins").add_child(newCoin)
    newCoin.translation = translation
    newCoin.was_just_thrown = true
    newCoin.grav = 80
    num_coins_spawned += 1
    coinSpawnTimer = 0
    spitSound.play()

func isActive():
    return visible and can_activate

func activate():
    if can_activate:
        self.spawnCoin()
        can_activate = false
