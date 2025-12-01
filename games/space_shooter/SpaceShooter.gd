class_name SpaceShooter
extends Node2D

@export var enemy_scene: PackedScene

var enemies_destroyed: int = 0
var screen_size: Vector2
var current_spawn_rate: float
var enemy_timer: Timer

func _ready() -> void:
	screen_size = get_viewport_rect().size
	GlobalState.reset_game_state()
	current_spawn_rate = GameConstants.INITIAL_SPAWN_RATE
	_setup_timers()
	_connect_signals()

func _setup_timers() -> void:
	enemy_timer = Timer.new()
	enemy_timer.name = "EnemyTimer"
	enemy_timer.wait_time = current_spawn_rate
	enemy_timer.timeout.connect(_spawn_enemy)
	add_child(enemy_timer)
	enemy_timer.start()

func _connect_signals() -> void:
	EventBus.enemy_destroyed.connect(_on_enemy_destroyed)
	EventBus.player_died.connect(_on_player_died)
	EventBus.game_state_changed.connect(_on_game_state_changed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if GlobalState.current_game_state == GameConstants.GameState.PLAYING:
			GlobalState.toggle_pause()
		elif GlobalState.current_game_state == GameConstants.GameState.PAUSED:
			GlobalState.toggle_pause()
		else:
			_go_back_to_lobby()

func _spawn_enemy() -> void:
	if GlobalState.current_game_state != GameConstants.GameState.PLAYING:
		return
	
	var current_enemies := get_tree().get_nodes_in_group("enemies")
	if current_enemies.size() >= GameConstants.MAX_ENEMIES:
		return
	
	if not enemy_scene:
		push_error("Enemy scene not assigned")
		return
	
	var enemy: Enemy = enemy_scene.instantiate()
	if not enemy:
		push_error("Failed to instantiate enemy")
		return
	
	# Set enemy type based on wave progression
	enemy.enemy_type = _get_enemy_type_for_wave()
	enemy.position = Vector2(randf_range(50, screen_size.x - 50), -50)
	add_child(enemy)

func _get_enemy_type_for_wave() -> GameConstants.EnemyType:
	var rand := randf()
	var wave := GlobalState.wave
	
	if wave < 3:
		return GameConstants.EnemyType.BASIC
	elif wave < 6:
		return GameConstants.EnemyType.FAST if rand < 0.3 else GameConstants.EnemyType.BASIC
	else:
		if rand < 0.1:
			return GameConstants.EnemyType.HEAVY
		elif rand < 0.4:
			return GameConstants.EnemyType.FAST
		else:
			return GameConstants.EnemyType.BASIC

func _on_enemy_destroyed(enemy_type: GameConstants.EnemyType) -> void:
	enemies_destroyed += 1
	
	if enemies_destroyed % 8 == 0:
		_increase_difficulty()

func _on_player_died(remaining_lives: int) -> void:
	if remaining_lives <= 0:
		_end_game()

func _increase_difficulty() -> void:
	GlobalState.wave += 1
	current_spawn_rate = max(GameConstants.MIN_SPAWN_RATE, current_spawn_rate - 0.05)
	enemy_timer.wait_time = current_spawn_rate
	EventBus.wave_started.emit(GlobalState.wave)

func _end_game() -> void:
	GlobalState.set_game_state(GameConstants.GameState.GAME_OVER)
	enemy_timer.stop()
	EventBus.game_over.emit(GlobalState.score)
	await get_tree().create_timer(2.0).timeout
	_go_back_to_lobby()

func _on_game_state_changed(new_state: GameConstants.GameState) -> void:
	match new_state:
		GameConstants.GameState.PAUSED:
			enemy_timer.paused = true
		GameConstants.GameState.PLAYING:
			enemy_timer.paused = false
		GameConstants.GameState.GAME_OVER:
			enemy_timer.stop()

func _go_back_to_lobby() -> void:
	get_tree().change_scene_to_file("res://Lobby.tscn")
