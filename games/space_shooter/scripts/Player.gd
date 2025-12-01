extends Area2D

@export var speed = 400
var screen_size # Size of the game window.

var laser_scene: PackedScene

func _ready():
	add_to_group("players")
	screen_size = get_viewport_rect().size
	laser_scene = preload("res://games/space_shooter/scenes/Laser.tscn")

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)

	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var laser = laser_scene.instantiate()
	laser.position = position
	get_parent().add_child(laser)

func _on_area_entered(area):
	if area.is_in_group("enemies"):
		EventBus.player_died.emit()
		queue_free()
