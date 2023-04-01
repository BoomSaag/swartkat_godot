extends Area2D

@export var mouseSpeed : float = 300.0
@export var mouseScore : int = 100
var speedMultiplier : float = 1.0
var mouseDirection : int = 0
var velocity = Vector2.ZERO

func _ready():
	
	var randomChoice = randf_range(0.0,2.0)
	$AnimatedSprite2D.play("run")
	if randomChoice > 1.7:
		speedMultiplier = 2.0
	elif randomChoice > 1.5:
		speedMultiplier = 1.6
	else:
		pass
	$AnimatedSprite2D.speed_scale = speedMultiplier
	mouseScore *= round(speedMultiplier)

func mouseOrient(location, screenSize):
	# mouse movement direction: 0 = left to right, 1 = right to left
	if location.x > screenSize.x / 2:
		mouseDirection = 1
		$AnimatedSprite2D.flip_h = true
		$CPUParticles2D.gravity.y = -500
	else:
		mouseDirection = 0
		$AnimatedSprite2D.flip_h = false

func _physics_process(delta):
	
	if mouseDirection == 1:
		velocity = Vector2.LEFT * mouseSpeed * speedMultiplier
	else:	
		velocity = Vector2.RIGHT * mouseSpeed * speedMultiplier
		
	position += velocity * delta


func _on_left_screen_detect_screen_exited():
	queue_free()


func _on_body_entered(body):
	# Add mouse score to player score and delete mouse
	body.emit_signal("updateScore",mouseScore)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.hide()
	$sound_mouseEat.play()
	position = self.position
	set_physics_process(false)
	await get_tree().create_timer(2.0).timeout
	$CPUParticles2D.emitting = false
	queue_free()
