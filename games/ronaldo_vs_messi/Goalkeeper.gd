class_name Goalkeeper
extends CharacterBody2D

@export var dive_speed: float = 300.0

var start_position: Vector2
var is_diving: bool = false

func _ready() -> void:
    add_to_group("goalkeeper")
    start_position = global_position

func react_to_shot(shot_target_pos: Vector2) -> void:
    """React to the player's shot by diving towards a predicted point."""
    if is_diving:
        return

    is_diving = true
    
    # Simple AI: Dive towards the shot's target position.
    var dive_direction := (shot_target_pos - global_position).normalized()
    
    # FIX: Use the dive_direction to set the velocity, making the keeper move.
    velocity = dive_direction * dive_speed
    
    # Use a timer to stop the dive after a short period.
    await get_tree().create_timer(0.5).timeout
    velocity = Vector2.ZERO
    is_diving = false

func _physics_process(_delta: float) -> void:
    move_and_slide()

func reset_keeper() -> void:
    """Reset the goalkeeper to its starting position."""
    global_position = start_position
    velocity = Vector2.ZERO
    is_diving = false