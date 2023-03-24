extends Area2D

@export var despawnTime = 5.0
@export var birdScore = 20

func _process(delta):
	# Bird is deleted if not eaten.
	await get_tree().create_timer(despawnTime).timeout
	queue_free()

func _ready():
	$AnimatedSprite2D.play()

func _on_body_entered(body):
	
	# Add bird score to player score and delete bird
	get_parent().get_parent().update_score(birdScore)
#	get_tree().call_group("levels", "update_score",birdScore)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.hide()
	$EatBirdSound.play()
	$CPUParticles2D.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
