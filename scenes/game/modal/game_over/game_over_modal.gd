extends CanvasLayer

func _process(_delta):
	if Globals.game_mode == E.GAME_TYPE.SURVIVAL:
		$Background/VBox/Details/Margin/Label.text = ""
	else:
		var high_score = UserData.endless_high_score if Globals.game_mode == E.GAME_TYPE.ENDLESS else UserData.timed_high_score
		$Background/VBox/Details/Margin/Label.text = "High Score: %d\nScore: %d" % [high_score, Globals.score]

func _on_button_left_pressed():
	Sounds.click()
	Signals.emit_signal("ResetGame")

func _on_button_right_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")
