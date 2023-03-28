extends Node2D

@export var birdScene: PackedScene
@export var snakeScene: PackedScene
@export var mouseScene: PackedScene
@export var player_to_birdOffset = 100
@export var snakeDifficulty : int = 85
@onready var spawnPoints = get_tree().get_nodes_in_group("markers")
@onready var messageBox = $CanvasLayer/MessageLabel
var screenSize = Vector2.ZERO
var playerAlive = true

var score = 0

func _ready():
	screenSize = get_viewport_rect().size
	$CanvasLayer/Music_lvl01.play()
	
func _process(delta):
	randomize()
	if playerAlive == false:
		if Input.is_action_pressed("ui_select"):
			_playerReset()
	
	#Quit Game:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://main.tscn")

func update_score(points):
	score += points
	$CanvasLayer/ScoreLabel/TotalScore.text = str(score)

func spawnMouse():
	var edgeLeft = $CanvasLayer/mouseLeft.position
	var edgeRight = $CanvasLayer/mouseRight.position
	var mouseEdge = [$CanvasLayer/mouseLeft.position, $CanvasLayer/mouseRight.position]
	var mouse = mouseScene.instantiate()
	
	if randi_range(0, 200) > 185:
		# mouseStart - 0 = Left, 1 = right
		if $CanvasLayer/playerSprite.position.y < 600 and get_tree().get_nodes_in_group("bottomMobs").size() < 1:
			$CanvasLayer.add_child(mouse)
			mouse.position = mouseEdge[randi_range(0,1)]
			mouse.mouseOrient(mouse.position, screenSize)
		else:
			pass
	
func spawnBird():
	
	var currentBirds = []
	var usedPlatforms = []
	var playerLocation = get_node("CanvasLayer/playerSprite").position
	var pointIndex = randi() % spawnPoints.size()
	var birdLocation = spawnPoints[pointIndex].position
	var bird = birdScene.instantiate()
	
	# Chance of snake:
	var snakeChance = randi_range(0, 100)
	
	if snakeChance > snakeDifficulty:
		bird = snakeScene.instantiate()
	else:
		pass
	
	# Checks if another bird is already at the location before spawning a new bird.
	for i in get_tree().get_nodes_in_group("collectibles"):
		currentBirds.append(i.position)
		usedPlatforms.append(i.position.y)
		
	if currentBirds.has(birdLocation):
		pass
	# Checks that bird is not on the same platform as another
	elif usedPlatforms.has(birdLocation.y):
		pass
	elif (birdLocation.x - player_to_birdOffset) < playerLocation.x and playerLocation.x < (birdLocation.x + player_to_birdOffset) and (birdLocation.y - player_to_birdOffset) < playerLocation.y and playerLocation.y < (birdLocation.y + player_to_birdOffset):
		pass
#	elif birdLocation.y < playerLocation.y - player_to_birdOffset or birdLocation.y > playerLocation.y + player_to_birdOffset:
#		pass
		
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
