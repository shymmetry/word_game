extends VBoxContainer

func _process(_delta):
	$Score.text = "Score: %s" % Globals.score

func _on_restart_button_pressed():
	Sounds.click()
	Signals.emit_signal("StartGame")

func _on_main_menu_button_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")
