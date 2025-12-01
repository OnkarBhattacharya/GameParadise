extends Control

const GAME_CARDS_DATA = [
	{
		"title": "Space Shooter",
		"image": "res://games/space_shooter/assets/icon.svg",
		"scene_path": "res://games/space_shooter/SpaceShooter.tscn"
	},
	{
		"title": "Bubble Burst",
		"image": "res://games/bubble_burst/assets/bubble.png",
		"scene_path": "res://games/bubble_burst/scenes/BubbleBurst.tscn"
	},
	{
		"title": "Ronaldo vs Messi",
		"image": "res://games/ronaldo_vs_messi/assets/ball.png",
		"scene_path": "res://games/ronaldo_vs_messi/RonaldoVsMessi.tscn"
	}
]

func _ready() -> void:
	GlobalState.reset_game_state()
	_create_lobby_ui()

func _create_lobby_ui() -> void:
	# Clear existing children to prevent duplicates on scene reload
	for child in get_children():
		child.queue_free()

	# Main vertical container
	var main_vbox = VBoxContainer.new()
	main_vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 20)
	add_child(main_vbox)

	# Title Label
	var title_label = Label.new()
	title_label.text = "GameParadise"
	title_label.add_theme_font_size_override("font_size", 48)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_vbox.add_child(title_label)

	# Spacer
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 50)
	main_vbox.add_child(spacer)

	# Cards Container
	var cards_hbox = HBoxContainer.new()
	cards_hbox.alignment = HBoxContainer.ALIGNMENT_CENTER
	cards_hbox.add_theme_constant_override("separation", 20)
	main_vbox.add_child(cards_hbox)
	
	# Create a card for each game
	for game_data in GAME_CARDS_DATA:
		var card = _create_game_card(game_data.title, game_data.image, game_data.scene_path)
		cards_hbox.add_child(card)

func _create_game_card(title: String, image_path: String, scene_path: String) -> PanelContainer:
	# Card container
	var card = PanelContainer.new()
	card.custom_minimum_size = Vector2(250, 300)

	# Vertical layout inside the card
	var card_vbox = VBoxContainer.new()
	card_vbox.add_theme_constant_override("separation", 15)
	card.add_child(card_vbox)

	# Game Title
	var title_label = Label.new()
	title_label.text = title
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card_vbox.add_child(title_label)

	# Game Image
	var texture_rect = TextureRect.new()
	var texture = load(image_path)
	if not texture:
		texture = load("res://icon.svg")  # Fallback to default icon
		push_warning("Could not load image: %s, using fallback" % image_path)
	texture_rect.texture = texture
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	card_vbox.add_child(texture_rect)

	# Play Button
	var play_button = Button.new()
	play_button.text = "Play"
	play_button.pressed.connect(func(): get_tree().change_scene_to_file(scene_path))
	card_vbox.add_child(play_button)
	
	return card
