extends Control

@export var intermissionTime : int = 3

func changeLevel():
	await get_tree().create_timer(intermissionTime).timeout
	get_tree().change_scene_to_file(Globals.levels[Globals.currentLevel]["path"])

func _ready():
	$CenterContainer/VBoxContainer/CenterContainer/AnimatedSprite2D.play("default")
	$CenterContainer/VBoxContainer/levelLabel.text = Globals.levels[Globals.currentLevel]["name"]
	changeLevel()
