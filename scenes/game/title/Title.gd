extends Panel

func _ready():
	if Globals.game_mode == E.GAME_TYPE.ENDLESS:
		$TitleLabel.text = "Endless"
	elif Globals.game_mode == E.GAME_TYPE.TIMED:
		$TitleLabel.text = "Timed"
	elif Globals.game_mode == E.GAME_TYPE.SURVIVAL:
		$TitleLabel.text = "Round %d" % [Globals.current_round]

func _process(_delta):
	if Globals.game_mode == E.GAME_TYPE.SURVIVAL:
		$TitleLabel.text = "Round %d" % [Globals.current_round]

func _on_in_game_menu_button_pressed():
	Globals.paused = true
	Sounds.click()
	$"../../MenuModal".show()
