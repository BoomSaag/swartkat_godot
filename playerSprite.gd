extends CharacterBody2D

signal ouch
signal death

@export var SPEED = 600.0
@export var JUMP_VELOCITY = -900.0
var playerHealth = 99

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_size = Vector2.ZERO

func monitorHealth():
	if playerHealth < 33:
			$looseHearts.emitting = false
			emit_signal("death")
			

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * 2
		$CPUParticles2D.emitting = false
	
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		$JumpSound.play()
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("attack"):
		$CPUParticles2D.emitting = true
	else:
		$CPUParticles2D.emitting = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	position.x = clamp(position.x, 0 + $CollisionShape2D.shape.size.x/2, screen_size.x - $CollisionShape2D.shape.size.x/2)
	
	if velocity.x != 0:
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.flip_h = velocity.x > 0
	
	move_and_slide()
	monitorHealth()

func _on_ouch():
#	$looseHearts.emitting = true
	if playerHealth > 0:
		playerHealth -= 33
