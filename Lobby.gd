extends Control

func _on_space_shooter_card_pressed():
  get_tree().change_scene_to_file("res://SpaceShooter.tscn")

func _on_bubble_burst_card_pressed():
  get_tree().change_scene_to_file("res://BubbleBurst.tscn")
