class_name Ball
extends Area2D

signal goal_scored
signal ball_saved

var velocity: Vector2 = Vector2.ZERO
var angular_vel: float = 0.0
var is_sleeping: bool = true

func _ready() -> void:
    _setup_collision_detection()

## Sets up collision detection.
func _setup_collision_detection() -> void:
    var collision_shape := CollisionShape2D.new()
    var shape := CircleShape2D.new()
    shape.radius = 16.0
    collision_shape.shape = shape
    add_child(collision_shape)
    body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
    if not is_sleeping:
        position += velocity * delta
        rotation += angular_vel * delta
        velocity *= 0.98
        angular_vel *= 0.98

## Handles collisions with goal or goalkeeper.
func _on_body_entered(body: Node) -> void:
    if body.is_in_group("goal"):
        goal_scored.emit()
        velocity = Vector2.ZERO
        print("Goal!")
    elif body.is_in_group("goalkeeper"):
        ball_saved.emit()
        print("Saved by the keeper!")

## Applies impulse to ball to simulate shot.
func shoot(direction: Vector2, force: float) -> void:
    is_sleeping = false
    velocity = direction.normalized() * force

## Resets ball to starting position and state.
func reset_ball(start_position: Vector2) -> void:
    is_sleeping = true
    global_position = start_position
    velocity = Vector2.ZERO
    angular_vel = 0.0
