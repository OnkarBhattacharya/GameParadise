
extends CanvasLayer

class_name SpaceShooterHUD

@onready var score_label: Label
@onready var lives_label: Label
@onready var wave_label: Label
@onready var pause_menu: Control
@onready var game_over_screen: Control

func _ready() -> void:
    _create_ui()
    _connect_signals()
    update_display()

func _create_ui() -> void:
    # Score label
    score_label = Label.new()
    score_label.name = "ScoreLabel"
    score_label.add_theme_font_size_override("font_size", 20)
    score_label.position = Vector2(20, 20)
    add_child(score_label)
    
    # Lives label
    lives_label = Label.new()
    lives_label.name = "LivesLabel"
    lives_label.add_theme_font_size_override("font_size", 20)
    lives_label.position = Vector2(20, 50)
    add_child(lives_label)
    
    # Wave label
    wave_label = Label.new()
    wave_label.name = "WaveLabel"
    wave_label.add_theme_font_size_override("font_size", 20)
    wave_label.position = Vector2(20, 80)
    add_child(wave_label)
    
    _create_pause_menu()
    _create_game_over_screen()

func _create_pause_menu() -> void:
    pause_menu = Control.new()
    pause_menu.name = "PauseMenu"
    pause_menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    pause_menu.visible = false
    
    var bg = ColorRect.new()
    bg.color = Color(0, 0, 0, 0.7)
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    pause_menu.add_child(bg)
    
    var pause_label = Label.new()
    pause_label.text = "PAUSED\nPress ESC to Resume"
    pause_label.add_theme_font_size_override("font_size", 32)
    pause_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    pause_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    pause_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    pause_menu.add_child(pause_label)
    
    add_child(pause_menu)

func _create_game_over_screen() -> void:
    game_over_screen = Control.new()
    game_over_screen.name = "GameOverScreen"
    game_over_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    game_over_screen.visible = false
    
    var bg = ColorRect.new()
    bg.color = Color(0, 0, 0, 0.8)
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    game_over_screen.add_child(bg)
    
    var vbox = VBoxContainer.new()
    vbox.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    vbox.add_theme_constant_override("separation", 20)
    
    var game_over_label = Label.new()
    game_over_label.text = "GAME OVER"
    game_over_label.add_theme_font_size_override("font_size", 48)
    game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    vbox.add_child(game_over_label)
    
    var score_label_go = Label.new()
    score_label_go.name = "FinalScoreLabel"
    score_label_go.add_theme_font_size_override("font_size", 24)
    score_label_go.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    vbox.add_child(score_label_go)
    
    var restart_btn = Button.new()
    restart_btn.text = "Restart"
    restart_btn.pressed.connect(_on_restart_pressed)
    vbox.add_child(restart_btn)
    
    var menu_btn = Button.new()
    menu_btn.text = "Main Menu"
    menu_btn.pressed.connect(_on_main_menu_pressed)
    vbox.add_child(menu_btn)
    
    game_over_screen.add_child(vbox)
    add_child(game_over_screen)

func _connect_signals() -> void:
    EventBus.score_updated.connect(_on_score_updated)
    EventBus.game_paused.connect(_on_game_paused)
    EventBus.game_resumed.connect(_on_game_resumed)
    EventBus.game_state_changed.connect(_on_game_state_changed)

func update_display() -> void:
    if score_label:
        score_label.text = "Score: %d | High: %d" % [GlobalState.score, GlobalState.high_score]
    if lives_label:
        lives_label.text = "Lives: %d" % GlobalState.lives
    if wave_label:
        wave_label.text = "Wave: %d" % GlobalState.wave

func _on_score_updated(_new_score: int) -> void:
    update_display()

func _on_game_paused() -> void:
    if pause_menu:
        pause_menu.visible = true

func _on_game_resumed() -> void:
    if pause_menu:
        pause_menu.visible = false

func _on_game_state_changed(new_state: GameConstants.GameState) -> void:
    if new_state == GameConstants.GameState.GAME_OVER:
        show_game_over()

func show_game_over() -> void:
    if game_over_screen:
        game_over_screen.visible = true
        var final_label = game_over_screen.get_node_or_null("VBoxContainer/FinalScoreLabel")
        if final_label:
            final_label.text = "Final Score: %d\nHigh Score: %d" % [GlobalState.score, GlobalState.high_score]

func _on_restart_pressed() -> void:
    GlobalState.reset_game_state()
    get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
    GlobalState.reset_game_state()
    get_tree().change_scene_to_file("res://Lobby.tscn")

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        if GlobalState.current_game_state == GameConstants.GameState.PLAYING:
            GlobalState.toggle_pause()
        elif GlobalState.current_game_state == GameConstants.GameState.PAUSED:
            GlobalState.toggle_pause()
