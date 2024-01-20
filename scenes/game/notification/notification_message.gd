extends Label

func _ready():
	Sounds.notify()
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO).tween_property(self, "theme_override_colors/font_color", Color(0, 0, 0, 0), 8)
	tween.set_trans(Tween.TRANS_EXPO).parallel().tween_property(self, "theme_override_colors/font_outline_color", Color(0, 0, 0, 0), 8)

func set_message(message: String):
	self.text = message
