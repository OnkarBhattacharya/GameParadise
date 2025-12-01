extends Area2D

var speed = -800
var screen_size

func _ready():
	add_to_group("lasers")
	screen_size = get_viewport_rect().size

func _process(delta):
	position.y += speed * delta
	if position.y < 0:
		queue_free()
