extends ReferenceRect

func _ready():
	$MenuLabel.text = "Level %s" % Globals.current_level
	$Goal.text = Globals.level_data.win_text
