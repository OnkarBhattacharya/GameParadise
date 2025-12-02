
class_name Laser
extends Area2D

var screen_size: Vector2
var lifetime: float = 0.0
const MAX_LIFETIME: float = 3.0

func _ready() -> void:
	screen_size = get_viewport_rect().size
	add_to_group("lasers")
	_setup_collision()

## Sets up collision detection.
func _setup_collision() -> void:
	var collision_shape := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = GameConstants.LASER_COLLISION_SIZE
	collision_shape.shape = shape
	add_child(collision_shape)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	if GlobalState.is_paused:
		return
	
	lifetime += delta
	position.y -= GameConstants.LASER_SPEED * delta
	
	if position.y < -50 or lifetime > MAX_LIFETIME:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		_hit_enemy(area)

## Handles hitting an enemy.
func _hit_enemy(enemy_area: Area2D) -> void:
	var enemy = enemy_area.get_parent()
	if enemy and enemy.has_method("take_damage"):
		enemy.take_damage(1)
	queue_free()
