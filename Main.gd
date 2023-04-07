extends Control

signal userAdded(name, idx)
signal loadNames
var indexFile_path = Globals.lastPlayer_path
var screenSize = Vector2.ZERO
var state = 1
@export var newGameScene : PackedScene
var difficulty : String = "Easy"

"""
Settings Menu Setup Functions:
"""

func snakesCheck():
	if Globals.chanceSnake <= 10:
		difficulty = "Baby"
	elif Globals.chanceSnake <= 30:
		difficulty = "Easy"
	elif Globals.chanceSnake <= 60:
		difficulty = "Medium"
	elif Globals.chanceSnake <= 90:
		difficulty = "Hard"
	else:
		difficulty = "Crazy"


"""
End of Functions
"""

func launchCheck():
	
	# Load last user index - Who the last player was
	if FileAccess.file_exists(indexFile_path):
		var indexFile = FileAccess.open(indexFile_path, FileAccess.READ)
		Globals.playerIndex = indexFile.get_var()
	else:
		Globals.playerIndex = 0
	
	# Load User info
	if FileAccess.file_exists(Globals.savePath):
		var file = FileAccess.open(Globals.savePath, FileAccess.READ)
		Globals.playerRecord = file.get_var()
		Globals.playerName = Globals.playerRecord[Globals.playerIndex].name
		Globals.hiScore = Globals.playerRecord[Globals.playerIndex].hiscore
		print("file loaded")
		emit_signal("loadNames")
	else:
		Globals.hiScore = 0
		Globals.firstGame = true
		$"NewUserMenu/NU-CenterContainer/VBoxContainer/entryBack".hide()
		$MenuButtonBox.hide()
		$GameTitle.hide()
		$NewUserMenu.show()

# Update the players name in the whole of the Main Menu
func updateName():
	$MenuButtonBox/userName.text = "Hello " + Globals.playerName + "!"
	$userMenu/userCenterContainer/UserMenuBox/userName.text = "Current Player: \n" + Globals.playerName
	

func _ready():
	screenSize = get_viewport_rect().size
	$MenuMusic.play()
	$GameTitle/AnimationPlayer.play("titleGrow")
	$GameTitle/AnimationPlayer.queue("title_pulse")
	
	launchCheck()
	
	# Load current player name:
	updateName()
	
	# Snake chance setting:
	snakesCheck()
	$settingsMenu/CenterContainer/MenuBox/SnakeBox/SnakeValue.text = str(Globals.chanceSnake) + " " + difficulty
	$settingsMenu/CenterContainer/MenuBox/SnakeBox/SnakeSlider.value = Globals.chanceSnake
	
# Menu buttons:
func _on_new_game_button_up():
	get_tree().change_scene_to_file("res://inter_mission_screen.tscn")

# Access User Menu:
func _on_change_user_button_up():
	$MenuButtonBox.hide()
	$userMenu.show()
	$controlPanel.hide()
	$GameTitle.hide()

func _on_add_user_button_button_up():
	$userMenu.hide()
	$NewUserMenu.show()


func _on_user_back_button_button_up():
	$userMenu.hide()
	$MenuButtonBox.show()
	$GameTitle.show()

# Add New User Prompt:
func _on_line_edit_text_submitted(new_text:String):
	
	var playerList : Array = []
	for player in Globals.playerRecord:
		playerList.append(Globals.playerRecord[player].name)
	
	if new_text.length() == 0:
		$NewUserMenu/UserErrorEntry.text = "Error: You have entered an incorrect player name. Please do not enter a blank player name!"
		$NewUserMenu/UserErrorEntry.show()
		$NewUserMenu/NewUserTimer.start()
		
	elif new_text.begins_with(" ") or new_text.ends_with(" "):
		$NewUserMenu/UserErrorEntry.text = "Error: You have entered an incorrect player name. Please do not start or end your player name with a space!"
		$NewUserMenu/UserErrorEntry.show()
		$NewUserMenu/NewUserTimer.start()
	
	elif playerList.has(new_text):
		$NewUserMenu/UserErrorEntry.text = "Error: User already exists!"
		$NewUserMenu/UserErrorEntry.show()
		$NewUserMenu/NewUserTimer.start()
		
	else:
		Globals.playerName = new_text
		Globals.playerRecord[Globals.playerRecord.size()] = {"name": new_text, "hiscore": 0}
		$NewUserMenu.hide()
		$MenuButtonBox.hide()
		if Globals.firstGame:
			$"NewUserMenu/NU-CenterContainer/VBoxContainer/entryBack".show()
			$MenuButtonBox.show()
			$GameTitle.show()
		else:
			$userMenu.show()
		emit_signal("userAdded", new_text, Globals.playerIndex)
		updateName()
	$"NewUserMenu/NU-CenterContainer/VBoxContainer/LineEdit".clear()

# Hide user message box
func _on_new_user_timer_timeout():
	$NewUserMenu/UserErrorEntry.hide()
	
func _on_entry_back_button_up():
	$NewUserMenu.hide()
	$MenuButtonBox.hide()
	$userMenu.show()
	
	
# Access Settings Menu:
func _on_settings_button_up():
	$MenuButtonBox.hide()
	$settingsMenu.show()
	$controlPanel.hide()
	$GameTitle.hide()

func _on_music_slider_value_changed(value):
	Globals.musicVolume = value - 100.0
	$MenuMusic.volume_db = Globals.musicVolume
	$settingsMenu/CenterContainer/MenuBox/musicBox/volumeLevel.text = str(round(((value - 60)/40)*100))+"%"
	print(Globals.musicVolume)
	

func _on_snake_slider_value_changed(value):
	
	Globals.chanceSnake = int(value)
	snakesCheck()
	$settingsMenu/CenterContainer/MenuBox/SnakeBox/SnakeValue.text = str(Globals.chanceSnake) + " " + difficulty

func _on_back_button_button_up():
	$settingsMenu.hide()
	$MenuButtonBox.show()
	$GameTitle.show()

# Access Controls Menu:
func _on_controls_button_up():
	$controlPanel.show()

func _on_close_controls_button_up():
	$controlPanel.hide()

# Quit Game:
func _on_quit_game_button_up():
	get_tree().quit()




