extends AudioStreamPlayer

func activateScript():
    var playerCamera = get_node("../../../../Player/CameraY")
    playerCamera.forceRotation(360, 0)