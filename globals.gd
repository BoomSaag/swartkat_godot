extends Node

var playerName : String = "User"
var musicVolume : float = 0.0
var savePath = "user://playerScore.save"
var lastPlayer_path = "user://lastPlayer.save"
var birdScene: PackedScene = preload("res://bird.tscn")
var snakeScene: PackedScene = preload("res://snake.tscn")
var mouseScene: PackedScene = preload("res://mouse.tscn")
var firstGame : bool = false
var player_to_birdOffset = 100
var chanceSnake : int = 20
var currentLevel : int = 0
var playerRecord : Dictionary = {}
var playerIndex : int = 0
var hiScore : int = 0

# Settings File
var settingsPath = "user://settings.save"
var settings : Dictionary = {"lastPlayer": 0,"musicVol": 100, "soundVol": 100, "snakes": 20}

# Dictionary of levels
var levels : Dictionary = {
	0: {"path":"res://level_01.tscn", "name":"--Level 01--"},
	1: {"path":"res://level_02.tscn", "name":"--Level 02--"}
	}
