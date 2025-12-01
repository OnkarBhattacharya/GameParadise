extends Node2D

@export var bubble_scene: PackedScene = preload("res://games/bubble_burst/scenes/Bubble.tscn")

var score_label: Label

func _ready():
	GlobalState.score = 0
	score_label = Label.new()
	score_label.position = Vector2(20, 60)
	add_child(score_label)
	update_score_label()
	EventBus.bubble_popped.connect(_on_bubble_popped)

func _on_bubble_timer_timeout():
	var bubble = bubble_scene.instantiate()
	var screen_size = get_viewport_rect().size
	bubble.position = Vector2(randf_range(0, screen_size.x), screen_size.y + 50)
	bubble.linear_velocity = Vector2(0, -200)
	add_child(bubble)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Lobby.tscn")

func update_score_label():
	score_label.text = "Score: " + str(GlobalState.score)

func _on_bubble_popped():
	update_score_label()
