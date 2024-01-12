extends HFlowContainer

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")

func _on_next_level_button_pressed():
	Levels.set_current_level(Globals.current_level + 1)
	Signals.emit_signal("StartGame")
