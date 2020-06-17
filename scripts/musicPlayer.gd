extends Node

onready var titleThemePlayer = get_node("TitleThemePlayer")
onready var dungeonThemePlayer = get_node("DungeonThemePlayer")
onready var debugThemePlayer = get_node("DebugThemePlayer")
onready var casinoThemePlayer = get_node("CasinoThemePlayer")
onready var toxicThemePlayer = get_node("ToxicThemePlayer")
onready var suburbThemePlayer = get_node("SuburbThemePlayer")
onready var swampThemePlayer = get_node("SwampThemePlayer")
onready var solarChoirThemePlayer = get_node("SolarChoirThemePlayer")

func conductFromScenePath(path):
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
    elif path.find("Goddess") > 0:
        self.playSolarChoir()
    elif path.find("MainMenu") > 0:
        titleThemePlayer.play()
    
func stopAll():
    titleThemePlayer.stop()
    dungeonThemePlayer.stop()
    debugThemePlayer.stop()
    casinoThemePlayer.stop()
    toxicThemePlayer.stop()
    suburbThemePlayer.stop()
    swampThemePlayer.stop()

func playDungeon():
    if dungeonThemePlayer.is_playing(): return
    self.stopAll()
    dungeonThemePlayer.play()

func playDebug():
    if debugThemePlayer.is_playing(): return
    self.stopAll()
    debugThemePlayer.play()
    
func playCasino():
    if casinoThemePlayer.is_playing(): return
    self.stopAll()
    casinoThemePlayer.play()
    
# not britney spears, unfortunately
func playToxic():
    if toxicThemePlayer.is_playing(): return
    self.stopAll()
    toxicThemePlayer.play()

func playSuburb():
    if suburbThemePlayer.is_playing(): return
    self.stopAll()
    suburbThemePlayer.play()

func playSwamp():
    if swampThemePlayer.is_playing(): return
    self.stopAll()
    swampThemePlayer.play()

func playSolarChoir():
    if solarChoirThemePlayer.is_playing(): return
    self.stopAll()
    solarChoirThemePlayer.play()