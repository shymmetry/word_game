extends CanvasLayer

func _ready():
	if Globals.game_mode == E.GAME_TYPE.ENDLESS:
		$"Background/VBox/Title/Margin/Label".text = "Endless"
	elif Globals.game_mode == E.GAME_TYPE.TIMED:
		$"Background/VBox/Title/Margin/Label".text = "Timed"
	else:
		$"Background/VBox/Title/Margin/Label".text = "Survival"

func _on_button_left_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")

func _on_button_middle_pressed():
	Sounds.click()
	Signals.emit_signal("ResetGame")

func _on_back_pressed():
	Sounds.click()
	Globals.paused = false
	self.hide()
