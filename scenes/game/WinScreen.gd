extends VBoxContainer

func _on_main_menu_button_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")

func _on_next_level_button_pressed():
	Sounds.click()
	Levels.set_current_level(Globals.current_level + 1)
	Signals.emit_signal("StartGame")
