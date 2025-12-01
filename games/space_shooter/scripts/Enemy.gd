extends Area2D

var speed = 150
var screen_size

func _ready():
	add_to_group("enemies")
	screen_size = get_viewport_rect().size

func _process(delta):
	position.y += speed * delta
	if position.y > screen_size.y:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("players"):
		EventBus.player_died.emit()
		queue_free()
	if area.is_in_group("lasers"):
		GlobalState.score += 10
		EventBus.enemy_destroyed.emit()
		queue_free()
		area.queue_free()
