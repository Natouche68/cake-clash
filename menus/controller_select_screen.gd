extends CanvasLayer


@export var wasd_space_control_scheme_texture: Texture
@export var arrow_shift_control_scheme_texture: Texture
@export var controller_control_scheme_texture: Texture
@export var space_key_icon_texture: Texture
@export var shift_key_icon_texture: Texture
@export var button_a_icon_texture: Texture
@export var character_select_screen_scene: PackedScene

var current_player: int = 0


func _ready() -> void:
	show_control_scheme($Player1/PlayerControlScheme, PlayerManager.players_control_schemes[0])
	current_player += 1
	
	match PlayerManager.players_control_schemes[0]:
		PlayerManager.ControlScheme.WASD_SPACE:
			$ContinueLabel/ContinueButton.texture = space_key_icon_texture
		PlayerManager.ControlScheme.ARROWS_SHIFT:
			$ContinueLabel/ContinueButton.texture = shift_key_icon_texture
		PlayerManager.ControlScheme.CONTROLLER1:
			$ContinueLabel/ContinueButton.texture = button_a_icon_texture
		PlayerManager.ControlScheme.CONTROLLER2:
			$ContinueLabel/ContinueButton.texture = button_a_icon_texture
		PlayerManager.ControlScheme.CONTROLLER3:
			$ContinueLabel/ContinueButton.texture = button_a_icon_texture
		PlayerManager.ControlScheme.CONTROLLER4:
			$ContinueLabel/ContinueButton.texture = button_a_icon_texture
	
	$TitleBar.position.y = $TitleBar.position.y - 300
	$Player1/PlayerIcon.scale = Vector2.ZERO
	$Player1/PlayerControlScheme.scale = Vector2.ZERO
	$Player2/PlayerIcon.scale = Vector2.ZERO
	$Player2/PlayerControlScheme.scale = Vector2.ZERO
	$Player3/PlayerIcon.scale = Vector2.ZERO
	$Player3/PlayerControlScheme.scale = Vector2.ZERO
	$Player4/PlayerIcon.scale = Vector2.ZERO
	$Player4/PlayerControlScheme.scale = Vector2.ZERO
	$ContinueLabel.position.y = $ContinueLabel.position.y + 150
	
	var tween = create_tween()
	tween.tween_property($TitleBar, "position:y", $TitleBar.position.y + 300, 0.3)
	tween.tween_property($Player1/PlayerIcon, "scale", Vector2(0.6, 0.6), 0.1)
	tween.parallel().tween_property($Player1/PlayerControlScheme, "scale", Vector2(0.8, 0.8), 0.2)
	tween.tween_property($Player2/PlayerIcon, "scale", Vector2(0.6, 0.6), 0.1)
	tween.parallel().tween_property($Player2/PlayerControlScheme, "scale", Vector2(0.8, 0.8), 0.2)
	tween.tween_property($Player3/PlayerIcon, "scale", Vector2(0.6, 0.6), 0.1)
	tween.parallel().tween_property($Player3/PlayerControlScheme, "scale", Vector2(0.8, 0.8), 0.2)
	tween.tween_property($Player4/PlayerIcon, "scale", Vector2(0.6, 0.6), 0.1)
	tween.parallel().tween_property($Player4/PlayerControlScheme, "scale", Vector2(0.8, 0.8), 0.2)
	tween.tween_property($ContinueLabel, "position:y", $ContinueLabel.position.y - 150, 0.2)


func _process(_delta: float) -> void:
	if current_player > 1 and Input.is_action_just_pressed(PlayerManager.get_control_scheme_action(PlayerManager.players_control_schemes[0], PlayerManager.Action.DASH_ACCEPT)):
		var tween = create_tween()
		tween.tween_property($TitleBar, "position:y", $TitleBar.position.y - 300, 0.2)
		tween.tween_property($Player1/PlayerIcon, "scale", Vector2.ZERO, 0.1)
		tween.parallel().tween_property($Player1/PlayerControlScheme, "scale", Vector2.ZERO, 0.1)
		tween.tween_property($Player2/PlayerIcon, "scale", Vector2.ZERO, 0.1)
		tween.parallel().tween_property($Player2/PlayerControlScheme, "scale", Vector2.ZERO, 0.1)
		tween.tween_property($Player3/PlayerIcon, "scale", Vector2.ZERO, 0.1)
		tween.parallel().tween_property($Player3/PlayerControlScheme, "scale", Vector2.ZERO, 0.1)
		tween.tween_property($Player4/PlayerIcon, "scale", Vector2.ZERO, 0.1)
		tween.parallel().tween_property($Player4/PlayerControlScheme, "scale", Vector2.ZERO, 0.1)
		tween.tween_property($ContinueLabel, "position:y", $ContinueLabel.position.y + 150, 0.1)
		
		$ContinueAudioPlayer.play()
		
		await get_tree().create_timer(0.8).timeout
		get_tree().change_scene_to_packed(character_select_screen_scene)


func _input(event: InputEvent) -> void:
	if current_player != 0 and current_player < 4:
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_SPACE:
				if PlayerManager.players_control_schemes.find(PlayerManager.ControlScheme.WASD_SPACE) == -1:
					PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.WASD_SPACE)
					
					show_control_scheme(get_node("Player" + str(current_player + 1) + "/PlayerControlScheme"), PlayerManager.players_control_schemes[current_player])
					current_player += 1
			
			if event.keycode == KEY_SHIFT:
				if PlayerManager.players_control_schemes.find(PlayerManager.ControlScheme.ARROWS_SHIFT) == -1:
					PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.ARROWS_SHIFT)
					
					show_control_scheme(get_node("Player" + str(current_player + 1) + "/PlayerControlScheme"), PlayerManager.players_control_schemes[current_player])
					current_player += 1
		
		if event is InputEventJoypadButton and event.pressed and event.button_index == JOY_BUTTON_A:
			match event.device:
				0:
					if PlayerManager.players_control_schemes.find(PlayerManager.ControlScheme.CONTROLLER1) == -1:
						PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.CONTROLLER1)
						
						show_control_scheme(get_node("Player" + str(current_player + 1) + "/PlayerControlScheme"), PlayerManager.players_control_schemes[current_player])
						current_player += 1
				1:
					if PlayerManager.players_control_schemes.find(PlayerManager.ControlScheme.CONTROLLER2) == -1:
						PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.CONTROLLER2)
						
						show_control_scheme(get_node("Player" + str(current_player + 1) + "/PlayerControlScheme"), PlayerManager.players_control_schemes[current_player])
						current_player += 1
				2:
					if PlayerManager.players_control_schemes.find(PlayerManager.ControlScheme.CONTROLLER3) == -1:
						PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.CONTROLLER3)
						
						show_control_scheme(get_node("Player" + str(current_player + 1) + "/PlayerControlScheme"), PlayerManager.players_control_schemes[current_player])
						current_player += 1
				3:
					if PlayerManager.players_control_schemes.find(PlayerManager.ControlScheme.CONTROLLER4) == -1:
						PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.CONTROLLER4)
						
						show_control_scheme(get_node("Player" + str(current_player + 1) + "/PlayerControlScheme"), PlayerManager.players_control_schemes[current_player])
						current_player += 1


func show_control_scheme(player_scheme_node: TextureRect, player_chosen_scheme: PlayerManager.ControlScheme) -> void:
	if player_scheme_node != $Player1/PlayerControlScheme:
		var tween = create_tween()
		tween.tween_property(player_scheme_node, "scale", Vector2.ZERO, 0.1)
		tween.tween_property(player_scheme_node, "scale", Vector2(0.8, 0.8), 0.2)
		
		await get_tree().create_timer(0.1).timeout
		
		$ButtonClickedAudioPlayer.play()
	
	match player_chosen_scheme:
		PlayerManager.ControlScheme.WASD_SPACE:
			player_scheme_node.texture = wasd_space_control_scheme_texture
		PlayerManager.ControlScheme.ARROWS_SHIFT:
			player_scheme_node.texture = arrow_shift_control_scheme_texture
		PlayerManager.ControlScheme.CONTROLLER1:
			player_scheme_node.texture = controller_control_scheme_texture
		PlayerManager.ControlScheme.CONTROLLER2:
			player_scheme_node.texture = controller_control_scheme_texture
		PlayerManager.ControlScheme.CONTROLLER3:
			player_scheme_node.texture = controller_control_scheme_texture
		PlayerManager.ControlScheme.CONTROLLER4:
			player_scheme_node.texture = controller_control_scheme_texture
