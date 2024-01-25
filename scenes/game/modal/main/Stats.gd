extends VBoxContainer

func _process(_delta):
	$ResetSeconds.set_panel("Round Time", str(Globals.round_time))
	$Letters.set_panel("Minimum Letters", str(Globals.level_data.min_word_length))
	$Multipliers.set_panel("Multiplier Chance", "%d%%" % Globals.level_data.tile_type_chance[E.TILE_TYPE.MULTIPLIER])
