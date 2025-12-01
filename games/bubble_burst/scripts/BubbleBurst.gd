class_name BubbleBurst
extends Node2D

@export var bubble_scene: PackedScene

var bubbles_popped: int = 0
var bubbles_missed: int = 0
var screen_size: Vector2
var current_spawn_rate: float
var bubble_timer: Timer
var ui_container: Control
var score_label: Label
var level_label: Label
var time_label: Label
var game_time: float = 60.0  # 60 seconds per level
var remaining_time: float

func _ready() -> void:
	screen_size = get_viewport_rect().size
	GlobalState.reset_game_state()
	current_spawn_rate = GameConstants.BUBBLE_SPAWN_RATE
	remaining_time = game_time
	_setup_ui()
	_setup_timers()
	_connect_signals()

func _setup_ui() -> void:
	ui_container = Control.new()
	ui_container.name = "UI"
	add_child(ui_container)
	
	score_label = Label.new()
	score_label.name = "ScoreLabel"
	score_label.add_theme_font_size_override("font_size", GameConstants.FONT_SIZE_MEDIUM)
	score_label.position = Vector2(20, 20)
	score_label.text = "Score: 0 | High: %d" % GlobalState.high_score
	ui_container.add_child(score_label)
	
	level_label = Label.new()
	level_label.name = "LevelLabel"
	level_label.add_theme_font_size_override("font_size", GameConstants.FONT_SIZE_MEDIUM)
	level_label.position = Vector2(20, 50)
	level_label.text = "Level: %d" % GlobalState.level
	ui_container.add_child(level_label)
	
	time_label = Label.new()
	time_label.name = "TimeLabel"
	time_label.add_theme_font_size_override("font_size", GameConstants.FONT_SIZE_MEDIUM)
	time_label.position = Vector2(20, 80)
	ui_container.add_child(time_label)

func _setup_timers() -> void:
	bubble_timer = Timer.new()
	bubble_timer.wait_time = current_spawn_rate
	bubble_timer.timeout.connect(_spawn_bubble)
	add_child(bubble_timer)
	bubble_timer.start()

func _connect_signals() -> void:
	EventBus.bubble_popped.connect(_on_bubble_popped)
	EventBus.bubble_missed.connect(_on_bubble_missed)
	EventBus.game_state_changed.connect(_on_game_state_changed)

func _process(delta: float) -> void:
	if GlobalState.current_game_state == GameConstants.GameState.PLAYING:
		remaining_time -= delta
		time_label.text = "Time: %.1f" % remaining_time
		
		if remaining_time <= 0:
			_level_complete()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if GlobalState.current_game_state == GameConstants.GameState.PLAYING:
			GlobalState.toggle_pause()
		else:
			_go_back_to_lobby()

func _spawn_bubble() -> void:
	if GlobalState.current_game_state != GameConstants.GameState.PLAYING:
		return
	
	var current_bubbles := get_tree().get_nodes_in_group("bubbles")
	if current_bubbles.size() >= GameConstants.MAX_BUBBLES:
		return
	
	if not bubble_scene:
		push_error("Bubble scene not assigned")
		return
	
	var bubble: Bubble = bubble_scene.instantiate()
	if not bubble:
		return
	
	bubble.position = Vector2(randf_range(50, screen_size.x - 50), screen_size.y + 50)
	bubble.linear_velocity = Vector2(randf_range(-50, 50), -randf_range(150, 300))
	bubble.despawn_time = max(3.0, GameConstants.BUBBLE_DESPAWN_TIME - GlobalState.level * 0.5)
	add_child(bubble)

func _on_bubble_popped(points: int) -> void:
	bubbles_popped += 1
	_update_ui()
	
	if bubbles_popped % 15 == 0:
		_increase_difficulty()

func _on_bubble_missed() -> void:
	bubbles_missed += 1

func _increase_difficulty() -> void:
	GlobalState.level += 1
	current_spawn_rate = max(GameConstants.BUBBLE_MIN_SPAWN_RATE, current_spawn_rate - 0.1)
	bubble_timer.wait_time = current_spawn_rate
	EventBus.level_changed.emit(GlobalState.level)
	_update_ui()

func _level_complete() -> void:
	remaining_time = game_time
	GlobalState.add_score(int(remaining_time * 2))  # Bonus for remaining time
	_increase_difficulty()

func _update_ui() -> void:
	if score_label:
		score_label.text = "Score: %d | High: %d" % [GlobalState.score, GlobalState.high_score]
	if level_label:
		level_label.text = "Level: %d" % GlobalState.level

func _on_game_state_changed(new_state: GameConstants.GameState) -> void:
	match new_state:
		GameConstants.GameState.PAUSED:
			bubble_timer.paused = true
		GameConstants.GameState.PLAYING:
			bubble_timer.paused = false

func _go_back_to_lobby() -> void:
	get_tree().change_scene_to_file("res://Lobby.tscn")
