extends Node2D

@export var enemy_scene: PackedScene

func _on_EnemyTimer_timeout():
  var enemy = enemy_scene.instantiate()
  var screen_size = get_viewport_rect().size
  enemy.position = Vector2(randf_range(0, screen_size.x), -50)
  add_child(enemy)
