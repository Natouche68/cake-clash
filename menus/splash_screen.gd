extends CanvasLayer


@export var controller_select_screen_scene: PackedScene


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.WASD_SPACE)
			change_to_controller_select_menu()
		if event.keycode == KEY_SHIFT:
			PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.ARROWS_SHIFT)
			change_to_controller_select_menu()
	
	if event is InputEventJoypadButton and event.pressed and event.button_index == JOY_BUTTON_A:
		match event.device:
			0:
				PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.CONTROLLER1)
			1:
				PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.CONTROLLER2)
			2:
				PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.CONTROLLER3)
			3:
				PlayerManager.players_control_schemes.append(PlayerManager.ControlScheme.CONTROLLER4)
		
		change_to_controller_select_menu()


func change_to_controller_select_menu() -> void:
	var tween = create_tween()
	tween.tween_property($ScreenCenter/SpaceIcon, "scale", Vector2.ZERO, 0.1)
	tween.tween_property($ScreenCenter/ShiftIcon, "scale", Vector2.ZERO, 0.1)
	tween.tween_property($ScreenCenter/AButtonIcon, "scale", Vector2.ZERO, 0.1)
	tween.tween_property($ScreenCenter/Logo, "scale", Vector2.ZERO, 0.4)
	
	$ContinueAudioPlayer.play()
	
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_packed(controller_select_screen_scene)
