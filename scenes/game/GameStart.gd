extends VBoxContainer

func _ready():
	if Globals.current_level == 0:
		$MenuLabel.text = "Endless"
	else:
		$MenuLabel.text = "Level %s" % Globals.current_level
	$Goal.text = Globals.level_data.goal
	$LevelInfo.text = Globals.level_data.level_info

func _on_start_button_pressed():
	get_parent().get_parent().hide()
