extends Area2D

var speed = 300
var jump_height = 1000
var jump = 1000

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		velocity = Vector2.LEFT * speed
	if Input.is_action_pressed("ui_right"):
		velocity = Vector2.RIGHT * speed
	if Input.is_action_pressed("Jump"):
		pass
			
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x > 0
		
	position += velocity * delta
