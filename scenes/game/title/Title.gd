extends Panel

func _on_in_game_menu_button_pressed():
	Globals.paused = true
	Sounds.click()
	$"../../MenuModal".show()