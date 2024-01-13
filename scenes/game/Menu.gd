extends VBoxContainer

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")

func _on_restart_button_pressed():
	Signals.emit_signal("StartGame")

func _on_back_button_pressed():
	get_parent().get_parent().hide()
