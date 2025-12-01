
class_name Enemy
extends RigidBody2D

@export var enemy_type: GameConstants.EnemyType = GameConstants.EnemyType.BASIC
@export var health: int = 1
@export var points: int = 10

var screen_size: Vector2
var movement_pattern: Callable
var lifetime: float = 0.0
var max_health: int

func _ready() -> void:
	screen_size = get_viewport_rect().size
	max_health = health
	add_to_group("enemies")
	_setup_enemy_type()
	_setup_physics()
	_setup_collision()

func _setup_enemy_type() -> void:
	"""Configure enemy based on type."""
	match enemy_type:
		GameConstants.EnemyType.BASIC:
			health = 1
			points = 10
			linear_velocity = Vector2(0, randf_range(GameConstants.ENEMY_MIN_SPEED, GameConstants.ENEMY_MAX_SPEED))
			modulate = Color.WHITE
		
		GameConstants.EnemyType.FAST:
			health = 1
			points = 15
			linear_velocity = Vector2(0, randf_range(GameConstants.ENEMY_MAX_SPEED, GameConstants.ENEMY_MAX_SPEED * 1.5))
			modulate = Color.YELLOW
		
		GameConstants.EnemyType.HEAVY:
			health = 3
			points = 25
			linear_velocity = Vector2(0, randf_range(GameConstants.ENEMY_MIN_SPEED * 0.7, GameConstants.ENEMY_MIN_SPEED))
			modulate = Color.RED
			scale = Vector2(1.3, 1.3)

func _setup_physics() -> void:
	"""Setup physics properties."""
	gravity_scale = 0.0
	linear_damp = 0.0

func _setup_collision() -> void:
	"""Setup collision detection."""
	var area := Area2D.new()
	area.name = "HitArea"
	var collision_shape := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(32, 32) * scale  # Adjust based on enemy sprite
	collision_shape.shape = shape
	area.add_child(collision_shape)
	add_child(area)
	area.area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	if GlobalState.is_paused:
		return
	
	lifetime += delta
	
	# Apply movement pattern if set
	if movement_pattern.is_valid():
		movement_pattern.call(delta)
	
	# Remove if off-screen
	if position.y > screen_size.y + 100:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	"""Handle collision with lasers."""
	if area.is_in_group("lasers"):
		take_damage(1)
		area.queue_free()  # Remove the laser

func take_damage(damage: int) -> void:
	"""Take damage and handle destruction."""
	health -= damage
	
	# Visual feedback for damage
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	tween.tween_property(self, "modulate", _get_type_color(), 0.1)
	
	if health <= 0:
		destroy()

func _get_type_color() -> Color:
	"""Get the base color corresponding to the enemy type."""
	match enemy_type:
		GameConstants.EnemyType.BASIC:
			return Color.WHITE
		GameConstants.EnemyType.FAST:
			return Color.YELLOW
		GameConstants.EnemyType.HEAVY:
			return Color.RED
	return Color.WHITE # Default case

func destroy() -> void:
	"""Handle destruction, scoring, and effects."""
	set_physics_process(false)
	
	# Death animation
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(0.1, 0.1), 0.3)
	tween.tween_property(self, "rotation", rotation + PI * 2, 0.3)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.3)
	tween.tween_callback(queue_free)
	
	# Add score and emit signal
	GlobalState.add_score(points)
	EventBus.enemy_destroyed.emit(global_position, scale.x)

func set_movement_pattern(pattern: Callable) -> void:
	"""Set a custom movement pattern for this enemy."""
	movement_pattern = pattern
