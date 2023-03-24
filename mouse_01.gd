extends RigidBody2D

var speed = 200

func _on_body_entered(body):
	queue_free()
	print("fart")
