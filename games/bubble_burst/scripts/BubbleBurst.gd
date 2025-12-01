extends Node2D

func _ready():
  print("Bubble Burst is running!")

func _on_back_button_pressed():
  get_tree().change_scene_to_file("res://Lobby.tscn")
