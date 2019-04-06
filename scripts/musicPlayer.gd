extends Node

onready var titleThemePlayer = get_node("TitleThemePlayer")
onready var dungeonThemePlayer = get_node("DungeonThemePlayer")
onready var debugThemePlayer = get_node("DebugThemePlayer")
onready var casinoThemePlayer = get_node("CasinoThemePlayer")
onready var toxicThemePlayer = get_node("ToxicThemePlayer")
onready var suburbThemePlayer = get_node("SuburbThemePlayer")
onready var swampThemePlayer = get_node("SwampThemePlayer")

func conductFromScenePath(path):
    print(path)
    if path.find("Intro") > 0:
        self.playDungeon()
    elif path.find("Debug") > 0:
        self.playDebug()
    elif path.find("Casino") > 0:
        self.playCasino()
    elif path.find("Forest") > 0 or path.find("Toxic") > 0:
        self.playToxic()
    elif path.find("Suburb") > 0:
        self.playSuburb()
    elif path.find("Swamp") > 0:
        self.playSwamp()
    
func stop():
    titleThemePlayer.stop()
    dungeonThemePlayer.stop()
    debugThemePlayer.stop()
    casinoThemePlayer.stop()
    toxicThemePlayer.stop()
    suburbThemePlayer.stop()
    swampThemePlayer.stop()

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

func playSuburb():
    self.stop()
    suburbThemePlayer.play()

func playSwamp():
    self.stop()
    swampThemePlayer.play()