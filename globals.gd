extends Node

var birdScene: PackedScene = preload("res://bird.tscn")
var snakeScene: PackedScene = preload("res://snake.tscn")
var mouseScene: PackedScene = preload("res://mouse.tscn")
var player_to_birdOffset = 100
var currentLevel : int = 0

# Dictionary of levels
var levels : Dictionary = {
	0: {"path":"res://level_01.tscn", "name":"--Level 01--"},
	1: {"path":"res://level_02.tscn", "name":"--Level 02--"}
	}
