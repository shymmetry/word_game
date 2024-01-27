extends Panel

func _process(_delta):
	$TitleLabel.text = "Round %d" % [Globals.current_round]

func _on_in_game_menu_button_pressed():
	Globals.paused = true
	Sounds.click()
	$"../../MenuModal".show()
