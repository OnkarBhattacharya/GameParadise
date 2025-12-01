class_name Ball
extends RigidBody2D

signal goal_scored
signal ball_saved

func _ready() -> void:
    # Corrected: Connect the 'body_entered' signal to the '_on_body_entered' method.
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
    """Handle collisions with the goal or goalkeeper."""
    if body.is_in_group("goal"):
        goal_scored.emit()
        # Stop the ball after a goal
        linear_velocity = Vector2.ZERO
        print("Goal!")
    elif body.is_in_group("goalkeeper"):
        ball_saved.emit()
        print("Saved by the keeper!")

func shoot(direction: Vector2, force: float) -> void:
    """Applies an impulse to the ball to simulate a shot."""
    # Ensure the ball is active to be able to move
    sleeping = false
    apply_central_impulse(direction.normalized() * force)

func reset_ball(start_position: Vector2) -> void:
    """Resets the ball to its starting position and state."""
    sleeping = true
    global_position = start_position
    linear_velocity = Vector2.ZERO
    angular_velocity = 0.0
