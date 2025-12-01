extends Node2D

@export var enemy_scene: PackedScene

func _ready():
  EventBus.enemy_destroyed.connect(Callable(self, "_on_enemy_destroyed"))

func _on_EnemyTimer_timeout():
  var enemy = enemy_scene.instantiate()
  var screen_size = get_viewport_rect().size
  enemy.position = Vector2(randf_range(0, screen_size.x), -50)
  add_child(enemy)

func _on_enemy_destroyed():
  print("Enemy destroyed! Score: ", GlobalState.score)
