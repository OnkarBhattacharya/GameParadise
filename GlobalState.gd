extends Node

# Game state variables
var score: int = 0
var level: int = 1
var wave: int = 1
var high_score: int = 0
var lives: int = GameConstants.INITIAL_LIVES
var current_game_state: GameConstants.GameState = GameConstants.GameState.MENU
var is_paused: bool = false

# Game settings
var master_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 1.0

func _ready() -> void:
	_load_high_score()
	EventBus.game_paused.connect(_on_game_paused)
	EventBus.game_resumed.connect(_on_game_resumed)

## Resets all game state variables to initial values.
func reset_game_state() -> void:
	if score > high_score:
		high_score = score
		_save_high_score()
	score = 0
	level = 1
	wave = 1
	lives = GameConstants.INITIAL_LIVES
	set_game_state(GameConstants.GameState.MENU)

## Adds points to the current score with validation.
func add_score(points: int) -> void:
	if points < 0:
		push_warning("Attempted to add negative score: %d" % points)
		return
	
	score += points
	EventBus.score_updated.emit(score)

## Changes the current game state and emits signal.
func set_game_state(new_state: GameConstants.GameState) -> void:
	if current_game_state != new_state:
		current_game_state = new_state
		EventBus.game_state_changed.emit(new_state)

## Toggles pause state and emits appropriate signals.
func toggle_pause() -> void:
	if current_game_state != GameConstants.GameState.PLAYING:
		return
	
	is_paused = !is_paused
	get_tree().paused = is_paused
	
	if is_paused:
		EventBus.game_paused.emit()
	else:
		EventBus.game_resumed.emit()

func _on_game_paused() -> void:
	set_game_state(GameConstants.GameState.PAUSED)

func _on_game_resumed() -> void:
	set_game_state(GameConstants.GameState.PLAYING)

func _save_high_score() -> void:
	"""Save high score to user data."""
	var config := ConfigFile.new()
	config.set_value("game", "high_score", high_score)
	config.save("user://save_game.cfg")

func _load_high_score() -> void:
	"""Load high score from user data."""
	var config := ConfigFile.new()
	if config.load("user://save_game.cfg") == OK:
		high_score = config.get_value("game", "high_score", 0)
