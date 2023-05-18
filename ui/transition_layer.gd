extends CanvasLayer


func _ready() -> void:
	$ColorRect.color = Color("#000000", 0.0)


func transition_fade_in_out(fade_time: float) -> void:
	var tween = create_tween()
	tween.tween_property($ColorRect, "color", Color("#000000", 1.0), fade_time)
	tween.tween_property($ColorRect, "color", Color("#000000", 0.0), fade_time)
