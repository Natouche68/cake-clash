extends CanvasLayer


@export var leaderboard_row_scene: PackedScene
@export var space_key_icon_texture: Texture
@export var shift_key_icon_texture: Texture
@export var button_a_icon_texture: Texture

@onready var leaderboard = $"..".leaderboard


func _ready() -> void:
	var i: int = 0
	
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
	
	for player in leaderboard:
		var new_row = leaderboard_row_scene.instantiate()
		
		new_row.position.x = 640
		new_row.position.y = 200 * i + 160
		
		new_row.player = player
		new_row.player_place = i + 1
		new_row.start_animation_delay = 0.5 * leaderboard.size() - i * 0.5
		
		if i != 0:
			new_row.scale = Vector2(0.8, 0.8)
		else:
			new_row.position.y -= 50
		
		add_child(new_row)
		
		i += 1
	
	await get_tree().create_timer(0.5).timeout
	$WinAudioPlayer.play()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(PlayerManager.get_control_scheme_action(PlayerManager.players_control_schemes[0], PlayerManager.Action.DASH_ACCEPT)):
		$ContinueAudioPlayer.play()
		TransitionLayer.transition_fade_in_out(0.8)
		await get_tree().create_timer(0.8).timeout
		get_tree().change_scene_to_file("res://menus/character_select_screen.tscn")
