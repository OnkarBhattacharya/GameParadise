class_name Player
extends CharacterBody2D

@export var laser_scene: PackedScene
@export var invulnerability_time: float = 2.0

var screen_size: Vector2
var can_shoot: bool = true
var is_invulnerable: bool = false
var last_shot_time: float = 0.0
var hit_area: Area2D

func _ready() -> void:
	screen_size = get_viewport_rect().size
	_setup_collision()
	_connect_signals()
	GlobalState.set_game_state(GameConstants.GameState.PLAYING)

func _setup_collision() -> void:
	"""Setup collision detection for the player."""
	hit_area = Area2D.new()
	hit_area.name = "HitArea"
	var collision_shape := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(32, 32)  # Adjust based on player sprite
	collision_shape.shape = shape
	hit_area.add_child(collision_shape)
	add_child(hit_area)
	hit_area.area_entered.connect(_on_area_entered)

func _connect_signals() -> void:
	"""Connect to relevant EventBus signals."""
	EventBus.game_paused.connect(_on_game_paused)
	EventBus.game_resumed.connect(_on_game_resumed)

func _physics_process(delta: float) -> void:
	if GlobalState.is_paused:
		return
	
	_handle_movement(delta)
	_handle_shooting(delta)
	move_and_slide()

func _handle_movement(delta: float) -> void:
	"""Handle player movement with proper physics."""
	var input_vector := Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1.0
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1.0
	
	velocity.x = input_vector.x * GameConstants.PLAYER_SPEED
	
	# Only clamp position when moving or near boundaries
	if input_vector.x != 0.0 or position.x < 32.0 or position.x > screen_size.x - 32.0:
		position.x = clamp(position.x, 32.0, screen_size.x - 32.0)

func _handle_shooting(delta: float) -> void:
	"""Handle shooting with proper debouncing."""
	last_shot_time += delta
	
	if Input.is_action_pressed("shoot") and can_shoot and last_shot_time >= GameConstants.FIRE_RATE:
		shoot()
		last_shot_time = 0.0

func shoot() -> void:
	"""Fire a laser with proper error handling."""
	if not laser_scene:
		push_error("Laser scene not assigned to Player")
		return
	
	if not get_parent():
		push_error("Player has no parent to add laser to")
		return
	
	var laser: Area2D = laser_scene.instantiate()
	if not laser:
		push_error("Failed to instantiate laser scene")
		return
	
	laser.position = global_position + Vector2(0, -20)  # Offset from player center
	get_parent().add_child(laser)
	EventBus.laser_fired.emit()

func _on_area_entered(area: Area2D) -> void:
	"""Handle collision with enemies."""
	if is_invulnerable or not area.is_in_group("enemies"):
		return
	
	take_damage()

func take_damage() -> void:
	"""Handle taking damage with invulnerability frames."""
	if is_invulnerable:
		return
	
	GlobalState.lives -= 1
	EventBus.player_died.emit(GlobalState.lives)
	
	if GlobalState.lives <= 0:
		die()
	else:
		_start_invulnerability()

func _start_invulnerability() -> void:
	"""Start invulnerability period with visual feedback."""
	is_invulnerable = true
	
	# Visual feedback - blinking effect
	var tween := create_tween()
	tween.set_loops(int(invulnerability_time * 5))  # Blink 5 times per second
	tween.tween_property(self, "modulate:a", 0.3, 0.1)
	tween.tween_property(self, "modulate:a", 1.0, 0.1)
	
	# End invulnerability
	await get_tree().create_timer(invulnerability_time).timeout
	is_invulnerable = false
	modulate.a = 1.0

func die() -> void:
	"""Handle player death."""
	set_physics_process(false)
	hide()
	GlobalState.set_game_state(GameConstants.GameState.GAME_OVER)

func _on_game_paused() -> void:
	set_physics_process(false)

func _on_game_resumed() -> void:
	set_physics_process(true)
