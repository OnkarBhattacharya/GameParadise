extends Node2D

@export var enemy_scene: PackedScene

func _ready():
	GlobalState.score = 0
	EventBus.enemy_destroyed.connect(_on_enemy_destroyed)
	EventBus.player_died.connect(_on_player_died)

func _on_EnemyTimer_timeout():
	var enemy = enemy_scene.instantiate()
	var screen_size = get_viewport_rect().size
	enemy.position = Vector2(randf_range(0, screen_size.x), -50)
	add_child(enemy)

func _on_enemy_destroyed():
	$HUD.update_score()

func _on_player_died():
	print("Player died! Game Over.")
	get_tree().reload_current_scene()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Lobby.tscn")
