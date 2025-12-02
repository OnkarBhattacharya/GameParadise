
class_name RonaldoVsMessi
extends Node2D

# Scene node references
@onready var player = $PlayerCharacter
@onready var goalkeeper = $Goalkeeper
@onready var ball = $Ball
@onready var ball_start_position = $BallStartPosition

# UI References
@onready var score_label = $ScoreLabel
@onready var result_label = $ResultLabel

# Game state
var player_score: int = 0
var opponent_score: int = 0
var shots_taken: int = 0
const MAX_SHOTS: int = 5

func _ready() -> void:
	_connect_signals()
	_reset_round()
	_update_score_display()
	if result_label:
		result_label.hide()

## Connects to game signals.
func _connect_signals() -> void:
	if player:
		player.shot_taken.connect(_on_player_shot_taken)
	if ball:
		ball.goal_scored.connect(_on_ball_goal_scored)
		ball.ball_saved.connect(_on_ball_saved)

func _on_player_shot_taken(target_pos: Vector2) -> void:
	# FIX: Use the target_pos variable to make the goalkeeper react to the shot.
	if goalkeeper:
		goalkeeper.react_to_shot(target_pos)

func _on_ball_goal_scored() -> void:
	player_score += 1
	if result_label:
		result_label.text = "GOAL!"
		result_label.show()
	_end_round()

func _on_ball_saved() -> void:
	opponent_score += 1 # Conceptually, a save is a point for the opponent
	if result_label:
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

## Resets round for next shot.
func _reset_round() -> void:
	if result_label:
		result_label.hide()
	if player:
		player.reset_player()
	if goalkeeper:
		goalkeeper.reset_keeper()
	if ball and ball_start_position:
		ball.reset_ball(ball_start_position.global_position)

## Updates score display.
func _update_score_display() -> void:
	if score_label:
		score_label.text = "Score: %d - %d" % [player_score, opponent_score]

## Ends game and shows final score.
func _end_game() -> void:
	var final_text := "Final Score: %d - %d\n" % [player_score, opponent_score]
	if player_score > opponent_score:
		final_text += "You Win!"
	else:
		final_text += "You Lose!"
	
	if result_label:
		result_label.text = final_text
		result_label.show()
	
	# Disable further player input
	if player:
		player.can_shoot = false
