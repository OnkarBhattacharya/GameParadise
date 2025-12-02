class_name Bubble
extends Area2D

@export var despawn_time: float = GameConstants.BUBBLE_DESPAWN_TIME

var lifetime: float = 0.0
var screen_size: Vector2
var is_popped: bool = false
var points: int = GameConstants.BUBBLE_POINTS
var click_area: Area2D

func _ready() -> void:
	screen_size = get_viewport_rect().size
	add_to_group("bubbles")
	_setup_physics()
	_setup_click_detection()
	_setup_visuals()

## Sets up physics properties.
func _setup_physics() -> void:
	# Area2D doesn't have physics properties in Godot 4.x
	pass

## Sets up click detection area.
func _setup_click_detection() -> void:
	click_area = Area2D.new()
	click_area.name = "ClickArea"
	var collision_shape := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = GameConstants.BUBBLE_CLICK_RADIUS
	collision_shape.shape = shape
	click_area.add_child(collision_shape)
	add_child(click_area)
	click_area.input_event.connect(_on_input_event)

## Sets up visual appearance and animation.
func _setup_visuals() -> void:
	modulate = Color.from_hsv(randf_range(0, 1), 0.7, 1.0)
	
	var sprite = ColorRect.new()
	sprite.size = GameConstants.BUBBLE_SPRITE_SIZE
	sprite.position = GameConstants.BUBBLE_SPRITE_SIZE / -2.0
	sprite.color = modulate
	add_child(sprite)
	
	# Add subtle pulsing animation
	var tween := create_tween()
	tween.set_loops()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 1.0)
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 1.0)

func _physics_process(delta: float) -> void:
	if GlobalState.is_paused or is_popped:
		return
	
	lifetime += delta
	
	# Visual warning when about to despawn
	var time_ratio := lifetime / despawn_time
	if time_ratio > 0.7:
		var warning_alpha := sin(lifetime * 10.0) * 0.3 + 0.7
		modulate.a = warning_alpha
	
	if lifetime > despawn_time:
		despawn()
	
	if position.y < -100:
		queue_free()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if is_popped or GlobalState.is_paused:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pop()

## Pops bubble with animation and scoring.
func pop() -> void:
	if is_popped:
		return
	
	is_popped = true
	set_physics_process(false)
	
	# Pop animation with particle effect
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.8, 1.8), 0.2)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_callback(queue_free)
	
	# Calculate bonus points based on timing
	var time_bonus := int((1.0 - lifetime / despawn_time) * points)
	var total_points := points + time_bonus
	
	GlobalState.add_score(total_points)
	EventBus.bubble_popped.emit(total_points)

## Despawns bubble when time expires.
func despawn() -> void:
	if is_popped:
		return
	
	is_popped = true
	set_physics_process(false)
	
	# Despawn animation (bubble pops on its own)
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1, 0.3, 0.3, 0.3), 0.3)
	tween.tween_callback(queue_free)
	
	EventBus.bubble_missed.emit()
