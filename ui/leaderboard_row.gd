extends Control


@export var player1_color: Color
@export var player2_color: Color
@export var player3_color: Color
@export var player4_color: Color

var player: int
var player_place: int
var start_animation_delay: float


func _ready() -> void:
	$Player.text = "Player " + str(player + 1)
	$Character.texture = load(CharacterData.characters[PlayerManager.players_characters[player]]["sprite"])
	$Place.text = str(player_place)
	
	match player:
		0:
			$Background.modulate = player1_color
		1:
			$Background.modulate = player2_color
		2:
			$Background.modulate = player3_color
		3:
			$Background.modulate = player4_color
	
	$Background.scale = Vector2.ZERO
	$Place.scale = Vector2.ZERO
	$Character.scale = Vector2.ZERO
	$Player.scale = Vector2.ZERO
	
	var tween = create_tween()
	tween.tween_interval(start_animation_delay)
	tween.tween_property($Background, "scale", Vector2(1, 1), 0.1)
	tween.tween_property($Place, "scale", Vector2(1, 1), 0.1)
	tween.tween_property($Character, "scale", Vector2(0.8, 0.8), 0.1)
	tween.tween_property($Player, "scale", Vector2(1, 1), 0.1)
