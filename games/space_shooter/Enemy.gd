extends Area2D

func _process(delta):
    position.y += 100 * delta

func _on_screen_exited():
    queue_free()

func _on_body_entered(body):
	if body.is_in_group("lasers"):
		queue_free()
		body.queue_free()
		EventBus.enemy_destroyed.emit()
