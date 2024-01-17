extends CanvasLayer

func _ready():
	if Globals.current_level == 0:
		$"Background/Title/Margin/Label".text = "Endless"
	else:
		$"Background/Title/Margin/Label".text = "Level %s" % Globals.current_level
	$"Background/Details/Label".text = Globals.level_data.goal + "\n" + Globals.level_data.level_info

func _on_button_left_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")

func _on_button_middle_pressed():
	Sounds.click()
	Signals.emit_signal("StartGame")

func _on_button_right_pressed():
	Sounds.click()
	self.hide()
