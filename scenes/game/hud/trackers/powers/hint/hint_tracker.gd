extends Panel

func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed \
			and !Globals.paused:
		var hint_given = PowerUtil.hint(Globals.round_data.min_word_length, 6)
		if !hint_given: Sounds.error()
