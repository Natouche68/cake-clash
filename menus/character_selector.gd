extends Control

signal character_selected


@export var space_key_icon_texture: Texture
@export var shift_key_icon_texture: Texture
@export var button_a_icon_texture: Texture
@export var checkmark_texture: Texture
@export var current_player: int
@export var start_animation_delay: float

@onready var arrow_left_x_position: float = $ArrowLeft.position.x
@onready var arrow_right_x_position: float = $ArrowRight.position.x

var player_control_scheme: PlayerManager.ControlScheme
var is_character_selected: bool = false


func _ready() -> void:
	player_control_scheme = PlayerManager.players_control_schemes[current_player]
	
	$PlayerIcon.texture = load("res://menus/player " + str(current_player + 1) + " icon.png")
	
	match PlayerManager.players_control_schemes[current_player]:
		PlayerManager.ControlScheme.WASD_SPACE:
			$CheckmarkIcon.texture = space_key_icon_texture
		PlayerManager.ControlScheme.ARROWS_SHIFT:
			$CheckmarkIcon.texture = shift_key_icon_texture
		PlayerManager.ControlScheme.CONTROLLER1:
			$CheckmarkIcon.texture = button_a_icon_texture
		PlayerManager.ControlScheme.CONTROLLER2:
			$CheckmarkIcon.texture = button_a_icon_texture
		PlayerManager.ControlScheme.CONTROLLER3:
			$CheckmarkIcon.texture = button_a_icon_texture
		PlayerManager.ControlScheme.CONTROLLER4:
			$CheckmarkIcon.texture = button_a_icon_texture
	
	show_selected_character()
	
	$PlayerIcon.scale = Vector2.ZERO
	$Character.scale = Vector2.ZERO
	$ArrowLeft.scale = Vector2.ZERO
	$ArrowRight.scale = Vector2.ZERO
	$CheckmarkIcon.scale = Vector2.ZERO
	
	var tween = create_tween()
	tween.tween_interval(start_animation_delay)
	tween.tween_property($PlayerIcon, "scale", Vector2(0.6, 0.6), 0.1)
	tween.tween_property($Character, "scale", Vector2(1, 1), 0.2)
	tween.tween_property($ArrowLeft, "scale", Vector2(0.5, 0.5), 0.1)
	tween.parallel().tween_property($ArrowRight, "scale", Vector2(0.5, 0.5), 0.1)
	tween.tween_property($CheckmarkIcon, "scale", Vector2(0.4, 0.4), 0.1)


func _process(_delta: float) -> void:
	if not is_character_selected and Input.is_action_just_pressed(PlayerManager.get_control_scheme_action(player_control_scheme, PlayerManager.Action.MOVE_LEFT)):
		if PlayerManager.players_characters[current_player] == 0:
			PlayerManager.players_characters[current_player] = CharacterData.characters.size() - 1 as CharacterData.Character
		else:
			PlayerManager.players_characters[current_player] = PlayerManager.players_characters[current_player] - 1 as CharacterData.Character
		
		show_selected_character()
		
		$ButtonClickedAudioPlayer.play()
		
		var tween = create_tween()
		tween.tween_property($ArrowLeft, "position:x", arrow_left_x_position + -16, 0.1)
		tween.tween_property($ArrowLeft, "position:x", arrow_left_x_position, 0.1)
	
	if not is_character_selected and Input.is_action_just_pressed(PlayerManager.get_control_scheme_action(player_control_scheme, PlayerManager.Action.MOVE_RIGHT)):
		if PlayerManager.players_characters[current_player] == CharacterData.characters.size() - 1:
			PlayerManager.players_characters[current_player] = 0 as CharacterData.Character
		else:
			PlayerManager.players_characters[current_player] = PlayerManager.players_characters[current_player] + 1 as CharacterData.Character
		
		show_selected_character()
		
		$ButtonClickedAudioPlayer.play()
		
		var tween = create_tween()
		tween.tween_property($ArrowRight, "position:x", arrow_right_x_position + 16, 0.1)
		tween.tween_property($ArrowRight, "position:x", arrow_right_x_position, 0.1)
	
	if not is_character_selected and Input.is_action_just_pressed(PlayerManager.get_control_scheme_action(player_control_scheme, PlayerManager.Action.DASH_ACCEPT)):
		emit_signal("character_selected")
		is_character_selected = true
		
		$ContinueAudioPlayer.play()
		
		$CheckmarkIcon.scale = Vector2.ZERO
		$CheckmarkIcon.texture = checkmark_texture
		var tween = create_tween()
		tween.tween_property($CheckmarkIcon, "scale", Vector2(0.4, 0.4), 0.2)


func show_selected_character() -> void:
	$Character.texture = load(CharacterData.characters[PlayerManager.players_characters[current_player]]["sprite"])
