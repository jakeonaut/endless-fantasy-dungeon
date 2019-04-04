extends Node

onready var titleThemePlayer = get_node("TitleThemePlayer")
onready var dungeonThemePlayer = get_node("DungeonThemePlayer")
onready var debugThemePlayer = get_node("DebugThemePlayer")
onready var casinoThemePlayer = get_node("CasinoThemePlayer")
onready var toxicThemePlayer = get_node("ToxicThemePlayer")

func conductFromScenePath(path):
    if path.find("Intro") > 0:
        self.playDungeon()
    elif path.find("Debug") > 0:
        self.playDebug()
    elif path.find("Casino") > 0:
        self.playCasino()
    elif path.find("Forest") > 0 or path.find("Toxic"):
        self.playToxic()
    
func stop():
    titleThemePlayer.stop()
    dungeonThemePlayer.stop()
    debugThemePlayer.stop()
    casinoThemePlayer.stop()
    toxicThemePlayer.stop()

func playDungeon():
    self.stop()
    dungeonThemePlayer.play()

func playDebug():
    self.stop()
    debugThemePlayer.play()
    
func playCasino():
    self.stop()
    casinoThemePlayer.play()
    
# not britney spears, unfortunately
func playToxic():
    self.stop()
    toxicThemePlayer.play()