
class_name PlayerCharacter
extends Node2D

# Signal to notify the main game script that a shot has been taken.
# We pass the target position to help the goalkeeper AI react.
signal shot_taken(shot_target_pos)

@export var ball: Ball
@export var aim_target_sprite: Sprite2D
@export var shot_power: float = 1000.0

var can_shoot: bool = true

func _ready() -> void:
	if aim_target_sprite:
		aim_target_sprite.hide()

func _process(_delta: float) -> void:
	# FIX: The 'delta' parameter is not used, so it's prefixed with an underscore.
	# This function handles updating the aim target visual in real-time.
	if can_shoot and aim_target_sprite:
		_update_aim_target()

func _input(event: InputEvent) -> void:
	if not can_shoot:
		return

	# On mouse click or spacebar press, take the shot.
	if event.is_action_pressed("ui_accept"):
		shoot()

func _update_aim_target() -> void:
	"""Updates the position of the aiming sprite to follow the mouse."""
	aim_target_sprite.show()
	aim_target_sprite.global_position = get_global_mouse_position()

func shoot() -> void:
	"""Handles the logic for shooting the ball towards the aim target."""
	if not ball:
		push_error("Ball node not assigned to PlayerCharacter!")
		return

	can_shoot = false
	if aim_target_sprite:
		aim_target_sprite.hide()

	var shot_target_pos := get_global_mouse_position()
	var shot_direction := (shot_target_pos - ball.global_position)

	ball.shoot(shot_direction, shot_power)
	shot_taken.emit(shot_target_pos)

func reset_player() -> void:
	"""Resets the player's state to allow another shot."""
	can_shoot = true
