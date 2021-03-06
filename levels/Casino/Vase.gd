extends "res://scripts/ThrowableObject.gd"

onready var shatterSound = get_node("Sounds/ShatterSound")
onready var levelRoot = get_tree().get_root().get_node("level")

# TODO(jaketrower): doing stuff like this... is dangerous 
# see: https://www.reddit.com/r/godot/comments/ait6y8/preloading_in_godot_31_vs_30/
const coin_resource = preload("res://levels/Casino/coin.tscn")
export var num_coins = 1

var num_coins_spawned = 0
var coinSpawnTimer = 0
var coinSpawnTimeLimit = 2

func _process(delta):
    #._process(delta) # NOTE: This super method is called automatically
    # https://github.com/godotengine/godot/issues/6500

    if global.pauseGame: return

    if num_coins_spawned >= 1 and num_coins_spawned < num_coins:
        coinSpawnTimer += (delta*22)
        if coinSpawnTimer > coinSpawnTimeLimit:
            self.spawnCoin()

# @override
func landed():
    .landed() # super
    if has_initially_landed and was_planted and visible:
        shatterSound.play()
        hide()
        set_collision_mask_bit(1, false)
        self.spawnCoin()

        # kill glitch enemies
        var my_area = get_node("InteractionArea")
        var areas = my_area.get_overlapping_areas()
        for area in areas:
            if area.is_in_group("enemies") and area.has_method("GetHitByBroom"):
                area.GetHitByBroom()

func spawnCoin():
    var newCoin = coin_resource.instance()
    # TODO(jaketrower): This node container is an ASSUMPTION!!!
    levelRoot.get_node("coins").add_child(newCoin)
    newCoin.translation = translation
    newCoin.passiveActivate(0)
    coinSpawnTimer = 0
    num_coins_spawned += 1 
    # if num_coins_spawned >= num_coins:
    #     queue_free()
