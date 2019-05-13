extends Node

var hasLoadedGame = false
var memory = {}

var numCoins = 0
var numHearts = 3

var activeInteractor = null
var activeThrowableObject = null
var activeSavePoint = null

var playerJustFell = false
var cameraRotation = null

var pauseMoveInput = false # don't allow player physics or camera input??
var pauseGame = false

var greyTheme = preload("res://tiles.tres")
var blueTheme = preload("res://tiles_blue.tres")


var save_game_file = "user://savegame.save"
func saveGame():
    var save_game = File.new()
    save_game.open(save_game_file, File.WRITE)
    save_game.store_line(to_json(global.memory))
    save_game.close()

func loadGame():
    var save_game = File.new()
    if not save_game.file_exists("user://savegame.save"):
        return # Error! We don't have a save to load.
    
    # Load the file line by line and process that dictionary to restore
    # the object it represents.
    save_game.open(save_game_file, File.READ)
    
    global.memory = parse_json(save_game.get_line())
    while not save_game.eof_reached():
        var current_line = parse_json(save_game.get_line())
        
    save_game.close()