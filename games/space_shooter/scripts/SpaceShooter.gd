extends Node2D

@export var enemy_scene: PackedScene
@export var player_scene: PackedScene
@export var hud_scene: PackedScene

var screen_size: Vector2
var current_spawn_rate: float
var enemies_spawned: int = 0
var spawn_timer: Timer
var player: Player

func _ready() -> void:
	screen_size = get_viewport_rect().size
	GlobalState.reset_game_state()
	GlobalState.set_game_state(GameConstants.GameState.PLAYING)
	current_spawn_rate = GameConstants.INITIAL_SPAWN_RATE
	
	_setup_player()
	_setup_hud()
	_setup_timers()
	_connect_signals()

## Sets up player and adds to scene.
func _setup_player() -> void:
	if not player_scene:
		player_scene = preload("res://games/space_shooter/scenes/Player.tscn")
	
	player = player_scene.instantiate()
	player.position = Vector2(screen_size.x / 2, screen_size.y - 100)
	add_child(player)

## Sets up HUD and adds to scene.
func _setup_hud() -> void:
	if not hud_scene:
		hud_scene = preload("res://games/space_shooter/scenes/HUD.tscn")
	
	var hud = hud_scene.instantiate()
	add_child(hud)

## Sets up spawn timer.
func _setup_timers() -> void:
	spawn_timer = Timer.new()
	spawn_timer.name = "SpawnTimer"
	spawn_timer.wait_time = current_spawn_rate
	spawn_timer.timeout.connect(_spawn_enemy)
	add_child(spawn_timer)
	spawn_timer.start()

## Connects to event bus signals.
func _connect_signals() -> void:
	EventBus.enemy_destroyed.connect(_on_enemy_destroyed)
	EventBus.player_died.connect(_on_player_died)
	EventBus.game_state_changed.connect(_on_game_state_changed)

## Spawns enemy at random position.
func _spawn_enemy() -> void:
	if GlobalState.current_game_state != GameConstants.GameState.PLAYING:
		return
	
	var enemy_count = get_tree().get_nodes_in_group("enemies").size()
	if enemy_count >= GameConstants.MAX_ENEMIES:
		return
	
	if not enemy_scene:
		enemy_scene = preload("res://games/space_shooter/scenes/Enemy.tscn")
	
	var enemy: Enemy = enemy_scene.instantiate()
	if not enemy:
		push_error("Failed to instantiate enemy")
		return
	enemy.enemy_type = _get_enemy_type_for_wave()
	enemy.position = Vector2(randf_range(50, screen_size.x - 50), -50)
	add_child(enemy)
	enemies_spawned += 1

## Returns enemy type based on current wave.
func _get_enemy_type_for_wave() -> GameConstants.EnemyType:
	var rand = randf()
	var wave = GlobalState.wave
	
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

func _on_enemy_destroyed(_enemy_type: String) -> void:
	if enemies_spawned % 10 == 0:
		_increase_difficulty()

func _on_player_died(remaining_lives: int) -> void:
	if remaining_lives <= 0:
		_end_game()

func _on_game_state_changed(new_state: GameConstants.GameState) -> void:
	pass

## Increases difficulty and spawn rate.
func _increase_difficulty() -> void:
	GlobalState.wave += 1
	current_spawn_rate = max(GameConstants.MIN_SPAWN_RATE, current_spawn_rate * 0.9)
	spawn_timer.wait_time = current_spawn_rate
	spawn_timer.start()

## Ends game and cleans up.
func _end_game() -> void:
	GlobalState.set_game_state(GameConstants.GameState.GAME_OVER)
	get_tree().call_group("enemies", "queue_free")
	spawn_timer.stop()
