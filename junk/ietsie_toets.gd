extends Node2D

var number : int = 0
var compare : int = 10

func _process(delta):
	randomize()
	number = randi()

func _on_print_time_timeout():
	
	print(number % Globals.levels.size())
	print("________")
