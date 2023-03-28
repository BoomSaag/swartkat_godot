extends Control

var screenSize = Vector2.ZERO
var state = 1
@export var newGameScene : PackedScene

func _ready():
	screenSize = get_viewport_rect().size
	$MenuMusic.play()

# Title animation
func titlePulse(speed):
	var minSize = 720
	var maxSize = 750
	var growRate = 20
	
	while state == 0:
		if $GameTitle.size.y < maxSize:
			$GameTitle.size.y += growRate * speed
			await get_tree().create_timer(1).timeout
		else:
			state = 1
			
	while state == 1:
		if $GameTitle.size.y > minSize:
			$GameTitle.size.y -= growRate * speed
			await get_tree().create_timer(1).timeout
		else:
			state = 0
			


func _process(delta):
	titlePulse(delta)
	

# Menu buttons:
func _on_new_game_button_up():
	get_tree().change_scene_to_file("res://level_01.tscn")

func _on_controls_button_up():
	$controlPanel.visible = true

func _on_button_close_controls_button_up():
	$controlPanel.visible = false

func _on_quit_game_button_up():
	get_tree().quit()

