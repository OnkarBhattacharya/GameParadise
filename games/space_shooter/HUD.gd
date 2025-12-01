extends CanvasLayer

class_name HUD

@onready var score_label: Label
@onready var lives_label: Label
@onready var level_label: Label
@onready var pause_menu: Control

func _ready() -> void:
	_create_ui()
	_connect_signals()
	update_display()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		GlobalState.toggle_pause()

func update_display() -> void:
	"""Update all HUD elements with current game state."""
	if score_label:
		score_label.text = "Score: %d | High: %d" % [GlobalState.score, GlobalState.high_score]
	
	if lives_label:
		lives_label.text = "Lives: %d" % GlobalState.lives
	
	if level_label:
		level_label.text = "Level: %d" % GlobalState.level

func _create_ui() -> void:
	"""Create all UI elements programmatically."""
	# Score label
	score_label = Label.new()
	score_label.name = "ScoreLabel"
	score_label.add_theme_font_size_override("font_size", GameConstants.FONT_SIZE_LARGE)
	score_label.position = Vector2(20, 20)
	add_child(score_label)
	
	# Lives label
	lives_label = Label.new()
	lives_label.name = "LivesLabel"
	lives_label.add_theme_font_size_override("font_size", GameConstants.FONT_SIZE_MEDIUM)
	lives_label.position = Vector2(20, 50)
	add_child(lives_label)
	
	# Level label
	level_label = Label.new()
	level_label.name = "LevelLabel"
	level_label.add_theme_font_size_override("font_size", GameConstants.FONT_SIZE_MEDIUM)
	level_label.position = Vector2(20, 80)
	add_child(level_label)
	
	_create_pause_menu()

func _create_pause_menu() -> void:
	"""Create pause menu overlay."""
	pause_menu = Control.new()
	pause_menu.name = "PauseMenu"
	pause_menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_menu.visible = false
	
	# Semi-transparent background
	var bg := ColorRect.new()
	bg.color = Color(0, 0, 0, 0.7)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_menu.add_child(bg)
	
	# Pause text
	var pause_label := Label.new()
	pause_label.text = "PAUSED\nPress ESC to Resume"
	pause_label.add_theme_font_size_override("font_size", 32)
	pause_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	pause_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	pause_menu.add_child(pause_label)
	
	add_child(pause_menu)

func _connect_signals() -> void:
	"""Connect to relevant EventBus signals."""
	EventBus.score_updated.connect(_on_score_updated)
	EventBus.game_paused.connect(_on_game_paused)
	EventBus.game_resumed.connect(_on_game_resumed)
	EventBus.ui_update_requested.connect(update_display)

func _on_score_updated(_new_score: int) -> void:
	update_display()

func _on_game_paused() -> void:
	if pause_menu:
		pause_menu.visible = true

func _on_game_resumed() -> void:
	if pause_menu:
		pause_menu.visible = false
