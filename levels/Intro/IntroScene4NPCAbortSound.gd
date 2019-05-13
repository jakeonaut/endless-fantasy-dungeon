extends "res://scripts/AbortSound.gd"

func activateScript():
    get_node("../Text").set_bbcode(
        "ok if you really must know.\njust press arrow keys\nor click and drag\nto move \"camera eye\"")