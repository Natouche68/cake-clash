extends CanvasLayer


@export var character_selector_scene: PackedScene
@export var game_scene: PackedScene

var number_of_selected_characters: int = 0


func _ready() -> void:
	$TitleBar.position.y = $TitleBar.position.y - 300
	
	var tween = create_tween()
	tween.tween_property($TitleBar, "position:y", $TitleBar.position.y + 300, 0.3)
	
	for i in PlayerManager.players_control_schemes.size():
		if PlayerManager.players_characters.size() == i:
			PlayerManager.players_characters.append(CharacterData.Character.CUPCAKE)
		
		var new_character_selector = character_selector_scene.instantiate()
		new_character_selector.current_player = i
		new_character_selector.start_animation_delay = 0.3 + 0.1 * i
		
		match PlayerManager.players_control_schemes.size():
			2:
				new_character_selector.position.x = 548
			3:
				new_character_selector.position.x = 342
			4:
				new_character_selector.position.x = 136
		new_character_selector.position.x += 412 * i
		
		add_child(new_character_selector)
		new_character_selector.character_selected.connect(func():
			number_of_selected_characters += 1
			if number_of_selected_characters == PlayerManager.players_control_schemes.size():
				await get_tree().create_timer(0.4).timeout
				TransitionLayer.transition_fade_in_out(0.8)
				await get_tree().create_timer(0.8).timeout
				get_tree().change_scene_to_packed(game_scene)
		)
