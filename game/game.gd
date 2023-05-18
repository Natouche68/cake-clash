extends Node3D


@export var leaderboard_scene: PackedScene

var players: Array[CharacterBody3D] = []
var leaderboard: Array[int] = []
var is_game_over: bool


func _ready() -> void:
	var current_player: int = 0
	
	for current_player_control_scheme in PlayerManager.players_control_schemes:
		var player_scene_to_instantiate = load(CharacterData.characters[PlayerManager.players_characters[current_player]]["scene_path"])
		var new_player = player_scene_to_instantiate.instantiate()
		new_player.position = get_node("Player" + str(current_player + 1) + "Position").position
		new_player.player_number = current_player
		
		match current_player_control_scheme:
			PlayerManager.ControlScheme.WASD_SPACE:
				new_player.control_scheme = "wasd"
			PlayerManager.ControlScheme.ARROWS_SHIFT:
				new_player.control_scheme = "arrow"
			PlayerManager.ControlScheme.CONTROLLER1:
				new_player.control_scheme = "controller1"
			PlayerManager.ControlScheme.CONTROLLER2:
				new_player.control_scheme = "controller2"
			PlayerManager.ControlScheme.CONTROLLER3:
				new_player.control_scheme = "controller3"
			PlayerManager.ControlScheme.CONTROLLER4:
				new_player.control_scheme = "controller4"
		
		add_child(new_player)
		players.append(new_player)
		current_player += 1


func _process(_delta: float) -> void:
	if not is_game_over:
		var average_x_position = 0.0
		var average_z_position = 0.0
		
		for player in players:
			average_x_position += player.position.x
			average_z_position += player.position.z
		
		$CameraPivot.position = Vector3(average_x_position / (players.size() * 4), 0, average_z_position / (players.size() * 4))


func _on_fall_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		body.can_move = false
		leaderboard.push_front(body.player_number)
		
		if leaderboard.size() == PlayerManager.players_control_schemes.size() - 1:
			is_game_over = true
			
			if leaderboard.find(0) == -1:
				show_winner(0)
			elif leaderboard.find(1) == -1:
				show_winner(1)
			elif leaderboard.find(2) == -1:
				show_winner(2)
			elif leaderboard.find(3) == -1:
				show_winner(3)
			
			add_child(leaderboard_scene.instantiate())
		else:
			body.play_fall_sound()


func show_winner(winner_number: int) -> void:
	leaderboard.push_front(winner_number)
	players[winner_number].can_move = false
	
	var tween = create_tween()
	tween.tween_property($CameraPivot, "position", players[winner_number].position, 1)
	tween.parallel().tween_property($CameraPivot/Camera3D, "position", Vector3(4.5, 1.5, 6), 1)
	tween.parallel().tween_property($CameraPivot/Camera3D, "rotation_degrees", Vector3(-15, 0, 0), 1)


func _on_start_timer_timeout() -> void:
	for player in players:
		player.can_move = true


func screenshake(shake_amount: float) -> void:
	var h_shake_direction = randf_range(-shake_amount, shake_amount)
	var v_shake_direction = randf_range(-shake_amount, shake_amount)
	
	var tween = create_tween()
	tween.tween_property($CameraPivot/Camera3D, "h_offset", h_shake_direction, 0.1)
	tween.parallel().tween_property($CameraPivot/Camera3D, "v_offset", v_shake_direction, 0.1)
	tween.tween_property($CameraPivot/Camera3D, "h_offset", -h_shake_direction / 2, 0.1)
	tween.parallel().tween_property($CameraPivot/Camera3D, "v_offset", -v_shake_direction / 2, 0.1)
	tween.tween_property($CameraPivot/Camera3D, "h_offset", h_shake_direction / 4, 0.1)
	tween.parallel().tween_property($CameraPivot/Camera3D, "v_offset", v_shake_direction / 4, 0.1)
	tween.tween_property($CameraPivot/Camera3D, "h_offset", 0, 0.1)
	tween.parallel().tween_property($CameraPivot/Camera3D, "v_offset", 0, 0.1)
