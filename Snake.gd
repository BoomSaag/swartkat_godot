extends Area2D

@export var despawnTime = 4.0
var dealtDamage = false

func _process(delta):
	$AnimatedSprite2D.play()
	await get_tree().create_timer(despawnTime).timeout
	queue_free()


func _on_body_entered(body: CharacterBody2D):
	
	if dealtDamage == false:
		$CatOuchSound.play()
		body.get_node("looseHearts").emitting = true
		body.emit_signal("ouch")
		dealtDamage = true
		# prevent player from taking damage more than once a second:
		await get_tree().create_timer(1.5).timeout
		dealtDamage = false
