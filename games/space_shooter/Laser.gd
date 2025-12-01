extends Area2D

func _process(delta):
    position.y -= 500 * delta

func _on_screen_exited():
    queue_free()
