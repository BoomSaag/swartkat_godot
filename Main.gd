extends Control

signal userAdded(playerName, idx)
signal loadNames
var settingsPath = Globals.settingsPath
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
	if FileAccess.file_exists(settingsPath):
		var settingsFile = FileAccess.open(settingsPath, FileAccess.READ)
		var settings = settingsFile.get_var()
		Globals.playerIndex = settings.lastPlayer
		Globals.chanceSnake = settings.snakes
		Globals.musicVolume = settings.musicVol - 100
		
	else:
		Globals.playerIndex = 0
	
	# Load User info
	if FileAccess.file_exists(Globals.savePath):
		var file = FileAccess.open(Globals.savePath, FileAccess.READ)
		Globals.playerRecord = file.get_var()
		Globals.playerName = Globals.playerRecord[Globals.playerIndex].name
		Globals.hiScore = Globals.playerRecord[Globals.playerIndex].hiscore

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

# Get the player Names and HiScores for the HiScore Panel:
func populateScores(records : Dictionary):
	
	var names : String
	var scores : String
	var nameScore : Array
	var topSpots : int = 5
	
	for player in records:
		nameScore.append(records[player].values())
	
	# sort list descending
	nameScore.sort_custom(func(a, b): return a[1] > b[1])
	
	# Populate the HiScores in Menu:
	for i in nameScore:
		if topSpots > 0:
			names += i[0] + "\n"
			scores += " - " + var_to_str(i[1]) + "\n"
			topSpots -= 1
	topSpots = 5
	$"hiscoreScreen/VBoxContainer/HBoxScores/VBox-playerNames/playerNames".text = names
	$"hiscoreScreen/VBoxContainer/HBoxScores/VBox-Score/playerScores".text = scores


func _ready():
	screenSize = get_viewport_rect().size
	$GameTitle/AnimationPlayer.play("titleGrow")
	$GameTitle/AnimationPlayer.queue("title_pulse")
	
	launchCheck()
	
	var musSlider = Globals.musicVolume + 100
	$MenuMusic.volume_db = Globals.musicVolume
	$settingsMenu/CenterContainer/MenuBox/musicBox/musicSlider.value = musSlider
	$settingsMenu/CenterContainer/MenuBox/musicBox/volumeLevel.text = str(round(((musSlider - 70)/30)*100))+"%"
	$MenuMusic.play()
	# Load current player name:
	updateName()
	populateScores(Globals.playerRecord)
	# Snake chance setting:
	snakesCheck()
	$settingsMenu/CenterContainer/MenuBox/SnakeBox/SnakeValue.text = str(Globals.chanceSnake) + " " + difficulty
	$settingsMenu/CenterContainer/MenuBox/SnakeBox/SnakeSlider.value = Globals.chanceSnake
	
# Menu buttons:
func _on_new_game_button_up():
	
	Globals.settings.lastPlayer = Globals.playerIndex
	var file = FileAccess.open(settingsPath, FileAccess.WRITE)
	var recordFile = FileAccess.open(Globals.savePath, FileAccess.WRITE)
	file.store_var(Globals.settings)
	recordFile.store_var(Globals.playerRecord)
	Globals.currentScore = 0
	Globals.currentLevel = 0
	get_tree().change_scene_to_file("res://inter_mission_screen.tscn")

# Access User Menu:
func _on_change_user_button_up():
	$MenuButtonBox.hide()
	$userMenu.show()
	$controlPanel.hide()
	$GameTitle.hide()
	emit_signal("loadNames")

func _on_add_user_button_button_up():
	if Globals.playerRecord.size()<10:
		$userMenu.hide()
		$NewUserMenu.show()
	else:
		$userMenu/userCenterContainer/UserMenuBox/ErrorPrompt.visibility_layer = 1
		await get_tree().create_timer(5).timeout
		$userMenu/userCenterContainer/UserMenuBox/ErrorPrompt.visibility_layer = 0 

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
		Globals.hiScore = 0
		$NewUserMenu.hide()
		$MenuButtonBox.hide()
		if Globals.firstGame:
			$"NewUserMenu/NU-CenterContainer/VBoxContainer/entryBack".show()
			$MenuButtonBox.show()
			$GameTitle.show()
			Globals.firstGame = false
		else:
			$userMenu.show()
		emit_signal("userAdded", new_text, Globals.playerIndex)
		emit_signal("loadNames")
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
	Globals.settings.musicVol = value
	$MenuMusic.volume_db = Globals.musicVolume
	$settingsMenu/CenterContainer/MenuBox/musicBox/volumeLevel.text = str(round(((value - 70)/30)*100))+"%"

	

func _on_snake_slider_value_changed(value):
	
	Globals.chanceSnake = int(value)
	Globals.settings.snakes = int(value)
	snakesCheck()
	$settingsMenu/CenterContainer/MenuBox/SnakeBox/SnakeValue.text = str(Globals.chanceSnake) + " " + difficulty

func _on_back_button_button_up():
	$settingsMenu.hide()
	$MenuButtonBox.show()
	$GameTitle.show()

# Access Controls Menu:
func _on_controls_button_up():
	if $controlPanel.visible:
		$controlPanel.hide()
	else:
		$controlPanel.show()

func _on_close_controls_button_up():
	$controlPanel.hide()

# Access HiScore Menu:
func _on_high_scores_button_up():
	if $hiscoreScreen.visible:
		$hiscoreScreen.hide()
	else:
		$hiscoreScreen.show()

func _on_close_hi_score_button_up():
	$hiscoreScreen.hide()

# Quit Game:
func _on_quit_game_button_up():
	Globals.settings.lastPlayer = Globals.playerIndex
	var file = FileAccess.open(settingsPath, FileAccess.WRITE)
	var recordFile = FileAccess.open(Globals.savePath, FileAccess.WRITE)
	file.store_var(Globals.settings)
	recordFile.store_var(Globals.playerRecord)
	get_tree().quit()

