extends "res://scripts/levelScript.gd"

func _ready():
    ._ready() #super

    get_node("/root/musicPlayer").playDebug()