extends Node

var memory = {}

var numCoins = 0

var lastDoor = ""
var cameraRotation = null

var activeInteractor = null
var activeThrowableObject = null
var activeSavePoint = null

var pauseMoveInput = false # don't allow player physics or camera input??
var pauseGame = false

var greyTheme = preload("res://tiles.tres")
var blueTheme = preload("res://tiles_blue.tres")