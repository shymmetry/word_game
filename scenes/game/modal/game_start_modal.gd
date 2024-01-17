extends CanvasLayer

func _ready():
	if Globals.current_level == 0:
		$"Background/Title/Margin/Label".text = "Endless"
	else:
		$"Background/Title/Margin/Label".text = "Level %s" % Globals.current_level
	$"Background/Details/Label".text = Globals.level_data.goal + "\n" + Globals.level_data.level_info

func _on_button_middle_pressed():
	Sounds.click()
	self.hide()
