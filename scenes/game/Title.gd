extends Panel

func _on_in_game_menu_button_pressed():
	Sounds.click()
	$"../../MenuModal".show()
