extends CanvasLayer

func _on_button_left_pressed():
	Sounds.click()
	Levels.set_current_level(Globals.current_level + 1)
	Signals.emit_signal("ResetGame")

func _on_button_right_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")
