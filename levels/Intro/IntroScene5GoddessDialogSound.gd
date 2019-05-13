extends "res://scripts/AbortSound.gd"

func activateScript():
    get_tree().get_root().get_node("level/Player").getCamera().toggleNext()