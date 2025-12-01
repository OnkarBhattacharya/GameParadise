class_name Laser
extends RigidBody2D

var screen_size: Vector2
var lifetime: float = 0.0
const MAX_LIFETIME: float = 3.0

func _ready() -> void:
	screen_size = get_viewport_rect().size
	add_to_group("lasers")
	_setup_physics()
	_setup_collision()

func _setup_physics() -> void:
	"""Setup physics properties for the laser."""
	gravity_scale = 0.0
	linear_velocity = Vector2(0, -GameConstants.LASER_SPEED)
	linear_damp = 0.0

func _setup_collision() -> void:
	"""Setup collision detection."""
	var area := Area2D.new()
	area.name = "HitArea"
	var collision_shape := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(4, 16)  # Adjust based on laser sprite
	collision_shape.shape = shape
	area.add_child(collision_shape)
	add_child(area)
	area.area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	if GlobalState.is_paused:
		return
	
	lifetime += delta
	
	# Remove if off-screen or too old
	if position.y < -50 or lifetime > MAX_LIFETIME:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	"""Handle collision with enemies."""
	if area.is_in_group("enemies"):
		_hit_enemy(area)

func _hit_enemy(enemy: Area2D) -> void:
	"""Handle hitting an enemy."""
	if enemy.has_method("take_damage"):
		enemy.take_damage(1)
	queue_free()
