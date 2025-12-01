extends Control

const SPACE_SHOOTER_SCENE: String = "res://games/space_shooter/SpaceShooter.tscn"
const BUBBLE_BURST_SCENE: String = "res://games/bubble_burst/scenes/BubbleBurst.tscn"

func _ready() -> void:
	GlobalState.reset_score()

func _on_space_shooter_card_pressed() -> void:
	_change_game(SPACE_SHOOTER_SCENE)

func _on_bubble_burst_card_pressed() -> void:
	_change_game(BUBBLE_BURST_SCENE)

func _on_ronaldo_vs_messi_card_pressed() -> void:
	# NOTE: You will need to create this scene file.
	_change_game("res://games/ronaldo_vs_messi/RonaldoVsMessi.tscn")

func _change_game(scene_path: String) -> void:
	if ResourceLoader.exists(scene_path):
		get_tree().change_scene_to_file(scene_path)
	else:
		push_error("Scene not found: %s" % scene_path)
