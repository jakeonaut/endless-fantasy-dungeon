extends "TwinPlayerGameMover.gd"

var just_spawned_timer = 0
var spawn_time_limit = 10
var broom_state = 0

# var is_stone = false # defined in TwinPlayerGameMover.gd

func _ready():
    set_process_input(true)
    set_process(true)
    set_physics_process(true)

func wearCostume(costume):
    if costume == "normal": 
        mySprite.setNormalClothes()
    elif costume == "moth": 
        mySprite.setMothCostume()
    elif costume == "bugcatcher": 
        mySprite.setBugCatcherCostume()
    elif costume == "cleric": 
        mySprite.setClericCostume()
        jumpSound = get_node("Sounds/JumpOverallsSound")
    elif costume == "luckycat": 
        mySprite.setLuckyCatCostume()
    elif costume == "nightgown": 
        mySprite.setNightgown()
    global.memory["player_costume"] = costume
    
func _process(delta):
    if global.pauseGame: return

    just_spawned_timer += (delta*22)

func _physics_process(delta):
    # ._process_physics(delta) #NOTE: this super method is called automatically 
    # https://github.com/godotengine/godot/issues/6500
    pass

func faceDown():
    mySprite.faceDown()

func isActive():
    return visible

func activate():
    if not is_stone and just_spawned_timer >= spawn_time_limit:
        is_stone = true
        mySprite.get_material_override().set_albedo(Color(0.447059, 0.968627, 1))
        set_collision_mask_bit(1, true)