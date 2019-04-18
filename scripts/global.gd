extends Node

var memory = {}

var numCoins = 0
var numHearts = 3

var activeInteractor = null
var activeThrowableObject = null
var activeSavePoint = null

var lastDoor = ""
var playerJustFell = false
var cameraRotation = null
var lastOnGroundPoint = null

var pauseMoveInput = false # don't allow player physics or camera input??
var pauseGame = false

var greyTheme = preload("res://tiles.tres")
var blueTheme = preload("res://tiles_blue.tres")