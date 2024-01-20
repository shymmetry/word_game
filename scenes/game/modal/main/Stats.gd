extends VBoxContainer

func _process(_delta):
	$ResetSeconds.set_panel("Reset Seconds", str(Globals.reset_seconds))
	$Letters.set_panel("Minimum Letters", str(Globals.min_word_length))
	$Multipliers.set_panel("Multiplier Chance", "%d%%" % Globals.level_data.tile_type_chance[E.TILE_TYPE.MULTIPLIER])
