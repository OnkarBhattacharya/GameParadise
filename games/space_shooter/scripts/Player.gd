
class_name Player
extends CharacterBody2D

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
	


## Sets up collision detection for the player.
func _setup_collision() -> void:
	hit_area = Area2D.new()
	hit_area.name = "HitArea"
	hit_area.collision_layer = GameConstants.PLAYER_COLLISION_LAYER
	hit_area.collision_mask = GameConstants.PLAYER_COLLISION_MASK
	
	var collision_shape := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = GameConstants.PLAYER_COLLISION_SIZE
	collision_shape.shape = shape
	
	hit_area.add_child(collision_shape)
	add_child(hit_area)
	
	hit_area.area_entered.connect(_on_hit_area_entered)
	add_to_group("player")

func _connect_signals() -> void:
	EventBus.game_paused.connect(_on_game_paused)
	EventBus.game_resumed.connect(_on_game_resumed)

func _physics_process(delta: float) -> void:
	if GlobalState.is_paused:
		return
	
	_handle_movement(delta)
	_handle_shooting(delta)
	move_and_slide()

## Handles player movement input.
func _handle_movement(delta: float) -> void:
	var input_vector := Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1.0
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1.0
	
	velocity.x = input_vector.x * GameConstants.PLAYER_SPEED
	
	if input_vector.x != 0.0 or position.x < 32.0 or position.x > screen_size.x - 32.0:
		position.x = clamp(position.x, 32.0, screen_size.x - 32.0)

## Handles player shooting input.
func _handle_shooting(delta: float) -> void:
	last_shot_time += delta
	
	if Input.is_action_pressed("shoot") and can_shoot and last_shot_time >= GameConstants.FIRE_RATE:
		shoot()
		last_shot_time = 0.0

## Shoots a laser from player position.
func shoot() -> void:
	if not get_parent():
		push_error("Player has no parent to add laser to")
		return
	
	var laser = Laser.new()
	
	if not laser:
		push_error("Failed to instantiate laser")
		return
	
	laser.position = global_position + Vector2(0, -20)
	get_parent().add_child(laser)
	EventBus.laser_fired.emit()

func _on_hit_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		take_damage()
		area.queue_free()

## Processes player taking damage with invulnerability.
func take_damage() -> void:
	if is_invulnerable:
		return
	
	GlobalState.lives -= 1
	EventBus.player_died.emit()
	
	if GlobalState.lives <= 0:
		hide()
		hit_area.collision_mask = 0
	else:
		is_invulnerable = true
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.2, 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.set_loops(int(invulnerability_time / 0.4))
		
		await tween.finished
		is_invulnerable = false

func _on_game_paused() -> void:
	set_physics_process(false)

func _on_game_resumed() -> void:
	set_physics_process(true)
