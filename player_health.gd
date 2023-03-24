extends TextureProgressBar

@onready var health = get_node(".")

func _process(delta):
	self.value = get_parent().get_parent().get_node("CanvasLayer/playerSprite").playerHealth

func _on_player_sprite_ouch():
#	if health.value > 0:
#		health.value -= 33
	if health.value >= 66:
		$heart1.emitting = true
	elif health.value >= 33:
		$heart2.emitting = true
	elif health.value >= 0:
		$heart3.emitting = true
