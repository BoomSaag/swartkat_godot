extends Control

var screenSize = Vector2.ZERO
var state = 1
@export var newGameScene : PackedScene

func _ready():
	screenSize = get_viewport_rect().size
	$MenuMusic.play()
	$GameTitle/AnimationPlayer.play("titleGrow")
	$GameTitle/AnimationPlayer.queue("title_pulse")

func time():
	var number = randi()
	if await get_tree().create_timer(2).timeout:
		print(number)
		print(number % 10)
	
func _process(delta):
	time()
	

# Menu buttons:
func _on_new_game_button_up():
	get_tree().change_scene_to_file("res://inter_mission_screen.tscn")

func _on_controls_button_up():
	$controlPanel.visible = true

func _on_button_close_controls_button_up():
	$controlPanel.visible = false

func _on_quit_game_button_up():
	get_tree().quit()

