extends Spatial

onready var levelRoot = get_tree().get_root().get_node("level")

# TODO(jaketrower): doing stuff like this... is dangerous 
# see: https://www.reddit.com/r/godot/comments/ait6y8/preloading_in_godot_31_vs_30/
const coin_resource = preload("res://levels/Casino/coin.tscn")
export var num_coins = 5

var num_coins_spawned = 0
var coinSpawnTimer = 0
var coinSpawnTimeLimit = 5

func _ready():
    set_process(true)

func _process(delta):
    #._process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    if num_coins_spawned >= 1 and num_coins_spawned < num_coins:
        coinSpawnTimer += (delta*22)
        if coinSpawnTimer > coinSpawnTimeLimit:
            self.spawnCoin()

func spawnCoin():
    var newCoin = coin_resource.instance()
    # TODO(jaketrower): This node container is an ASSUMPTION!!!
    levelRoot.get_node("coins").add_child(newCoin)
    newCoin.translation = translation
    newCoin.was_just_thrown = true
    newCoin.grav = 80
    num_coins_spawned += 1
    coinSpawnTimer = 0

func isActive():
    return visible

func activate():
    self.spawnCoin()
