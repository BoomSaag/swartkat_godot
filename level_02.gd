extends Node2D

# See Globals.gd for the packed scenes that are preloaded

signal nextLevel

var snakeDifficulty : int = 100 - Globals.chanceSnake
@export var winScore : int = 7000
@onready var spawnPoints = get_tree().get_nodes_in_group("markers")
@onready var messageBox = $CanvasLayer/MessageLabel
var screenSize = Vector2.ZERO
var playerAlive = true
var levelBeaten = false
var score = Globals.currentScore


func _ready():
	screenSize = get_viewport_rect().size
	$CanvasLayer/Music_lvl01.play()


func _process(delta):
	randomize()
	if playerAlive == false:
		if Input.is_action_pressed("ui_select"):
			_playerReset()
	
	#Quit Game:
	if Input.is_action_pressed("quit_game"):
		get_tree().change_scene_to_file("res://main.tscn")
	
	beatLevel()


func update_score(points):
	score += points
	$CanvasLayer/ScoreLabel/TotalScore.text = str(score)
	
func beatLevel():
	
	if score >= winScore:
		if levelBeaten == false:
			emit_signal("nextLevel")
			levelBeaten = true
		

func spawnMouse():
	var edgeLeft = $CanvasLayer/mouseLeft.position
	var edgeRight = $CanvasLayer/mouseRight.position
	var mouseEdge = [$CanvasLayer/mouseLeft.position, $CanvasLayer/mouseRight.position]
	
	
	if randi_range(0, 200) > 185:
		var mouse = Globals.mouseScene.instantiate()
		# mouseStart - 0 = Left, 1 = right
		if $CanvasLayer/playerSprite.position.y < 600 and get_tree().get_nodes_in_group("bottomMobs").size() < 1:
			$CanvasLayer.add_child(mouse)
			mouse.position = mouseEdge[randi_range(0,1)]
			mouse.mouseOrient(mouse.position, screenSize)
		else:
			$CanvasLayer.add_child(mouse)
			mouse.queue_free()


func spawnBird():
	
	var currentBirds = []
	var usedPlatforms = []
	var offset = Globals.player_to_birdOffset
	var playerLocation = get_node("CanvasLayer/playerSprite").position
	var pointIndex = randi() % spawnPoints.size()
	var birdLocation = spawnPoints[pointIndex].position
	var bird
	
	# Chance of snake:
	var snakeChance = randi_range(0, 100)
	
	if snakeChance > snakeDifficulty:
		bird = Globals.snakeScene.instantiate()
	else:
		bird = Globals.birdScene.instantiate()
	
	# Checks if another bird is already at the location before spawning a new bird.
	for i in get_tree().get_nodes_in_group("collectibles"):
		currentBirds.append(i.position)
		usedPlatforms.append(i.position.y)
		
	if currentBirds.has(birdLocation):
		$CanvasLayer.add_child(bird)
		bird.queue_free()
	# Checks that bird is not on the same platform as another
	elif usedPlatforms.has(birdLocation.y):
		$CanvasLayer.add_child(bird)
		bird.queue_free()
	elif (birdLocation.x - offset) < playerLocation.x and playerLocation.x < (birdLocation.x + offset) and (birdLocation.y - offset) < playerLocation.y and playerLocation.y < (birdLocation.y + offset):
		$CanvasLayer.add_child(bird)
		bird.queue_free()

		
	else:
		$CanvasLayer.add_child(bird)
		bird.position = birdLocation


func _on_spawn_timer_timeout():
	spawnBird()
	spawnMouse()


func _playerDeath():
	$CanvasLayer/ScoreLabel.saveScore()
	$CanvasLayer/playerSprite.set_physics_process(false)
	$CanvasLayer/playerSprite/CollisionShape2D.set_deferred("disabled", true)
	$CanvasLayer/playerSprite.hide()
	$CanvasLayer/Music_lvl01.stop()
	await get_tree().create_timer(5.0).timeout
	playerAlive = false


func _playerReset():
	score = 0
	update_score(0)
	playerAlive = true
	$CanvasLayer/MessageLabel.hide()
	$CanvasLayer/Music_lvl01.play()
	$CanvasLayer/playerSprite.show()
	$CanvasLayer/playerSprite/CollisionShape2D.disabled = false
	$CanvasLayer/playerSprite.playerHealth = 99
	$CanvasLayer/playerSprite.position = $CanvasLayer/player_Spawn.position
	$CanvasLayer/playerSprite.set_physics_process(true)


func _deathText():
	# Text displayed when player dies
	messageBox.text = "-GAME OVER-\nPress SPACE to try again"
	$CanvasLayer/MessageLabel/GameOverSound.play()
	messageBox.visible = true
	messageBox.visible_characters = 0
	var textlength = $CanvasLayer/MessageLabel.get_total_character_count()
	while messageBox.visible_characters < textlength:
		await get_tree().create_timer(0.09).timeout
		messageBox.visible_characters += 1
	for n in 5:
		messageBox.visible = false
		await get_tree().create_timer(0.3).timeout
		messageBox.visible = true
		await get_tree().create_timer(0.3).timeout


func _on_player_sprite_death():
	_playerDeath()
	_deathText()


func _on_player_sprite_update_score(points):
	update_score(points)


func _on_next_level():
	
	Globals.currentScore = score
	messageBox.text = "YOU WIN!!!"
	$CanvasLayer/playerSprite.set_physics_process(false)
	$CanvasLayer/playerSprite/CollisionShape2D.set_deferred("disabled", true)
	$CanvasLayer/playerSprite.hide()
	$CanvasLayer/Music_lvl01.stop()
	$CanvasLayer/beatLevelMusic.play()
	messageBox.show()
	messageBox.visible_characters = 0
	var textlength = messageBox.get_total_character_count()
	while messageBox.visible_characters < textlength:
		await get_tree().create_timer(0.09).timeout
		messageBox.visible_characters += 1
	for n in 5:
		messageBox.hide()
		await get_tree().create_timer(0.3).timeout
		messageBox.show()
		await get_tree().create_timer(0.3).timeout
	await get_tree().create_timer(2).timeout
	Globals.currentLevel += 1
#	get_tree().change_scene_to_file("res://inter_mission_screen.tscn")
	get_tree().quit()
