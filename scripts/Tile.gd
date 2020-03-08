extends Node

onready var player = get_tree().get_root().get_node("level/Player")
onready var meshInstance = self.get_node("MeshInstance")
onready var floorMeshInstance = self.get_node("FloorMeshInstance")
onready var featherMeshInstance = self.get_node("FeatherMeshInstance")

func _ready():
    pass

func _process(_delta):
    # ._process(delta) #NOTE: this super method is called automatically 
    # https://github.com/godotengine/godot/issues/6500

    if player.glitch_form == player.GlitchForm.NORMAL:
        floorMeshInstance.visible = false
        featherMeshInstance.visible = false

        meshInstance.visible = true

    if player.glitch_form == player.GlitchForm.FLOOR:
        meshInstance.visible = false
        featherMeshInstance.visible = false

        floorMeshInstance.visible = true

    if player.glitch_form == player.GlitchForm.FEATHER:
        meshInstance.visible = false
        floorMeshInstance.visible = false

        featherMeshInstance.visible = true