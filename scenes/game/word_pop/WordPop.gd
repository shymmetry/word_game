extends Panel

func _ready():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -50), 3)
	tween.set_trans(Tween.TRANS_EXPO).parallel().tween_property($Word, "theme_override_colors/font_color", Color(0, 0, 0, 0), 3)
	tween.set_trans(Tween.TRANS_EXPO).parallel().tween_property($Word, "theme_override_colors/font_shadow_color", Color(0, 0, 0, 0), 3)
	tween.set_trans(Tween.TRANS_EXPO).parallel().tween_property($Word, "theme_override_colors/font_outline_color", Color(0, 0, 0, 0), 3)
	tween.tween_callback(func(): queue_free())
