
class_name RonaldoVsMessi
extends Node2D

# Scene node references
@export var player: PlayerCharacter
@export var goalkeeper: Goalkeeper
@export var ball: Ball
@export var ball_start_position: Marker2D

# UI References
@export var score_label: Label
@export var result_label: Label

# Game state
var player_score: int = 0
var opponent_score: int = 0
var shots_taken: int = 0
const MAX_SHOTS: int = 5

func _ready() -> void:
    GlobalState.reset_game_state()
    _connect_signals()
    _update_score_display()
    result_label.hide()
    _reset_round()

func _connect_signals() -> void:
    if not player or not ball or not goalkeeper:
        push_error("Required nodes are not assigned in RonaldoVsMessi script!")
        return
    
    player.shot_taken.connect(_on_player_shot_taken)
    ball.goal_scored.connect(_on_ball_goal_scored)
    ball.ball_saved.connect(_on_ball_saved)

func _on_player_shot_taken(_target_pos: Vector2) -> void:
    # FIX: Use the target_pos variable to make the goalkeeper react to the shot.
    if goalkeeper:
        goalkeeper.react_to_shot(_target_pos)

func _on_ball_goal_scored() -> void:
    player_score += 1
    result_label.text = "GOAL!"
    result_label.show()
    _end_round()

func _on_ball_saved() -> void:
    opponent_score += 1 # Conceptually, a save is a point for the opponent
    result_label.text = "SAVED!"
    result_label.show()
    _end_round()

func _end_round() -> void:
    shots_taken += 1
    _update_score_display()
    
    # Wait for a moment before resetting for the next shot
    await get_tree().create_timer(2.0).timeout
    
    if shots_taken >= MAX_SHOTS:
        _end_game()
    else:
        _reset_round()

func _reset_round() -> void:
    result_label.hide()
    player.reset_player()
    goalkeeper.reset_keeper()
    ball.reset_ball(ball_start_position.global_position)

func _update_score_display() -> void:
    score_label.text = "Score: %d - %d" % [player_score, opponent_score]

func _end_game() -> void:
    var final_text := "Final Score: %d - %d\n" % [player_score, opponent_score]
    if player_score > opponent_score:
        final_text += "You Win!"
    else:
        final_text += "You Lose!"
    
    result_label.text = final_text
    result_label.show()
    
    # Disable further player input
    player.can_shoot = false
