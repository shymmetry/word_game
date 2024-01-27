extends VBoxContainer

func _process(_delta):
	$Letters.set_panel("Minimum Letters", str(Globals.round_data.min_word_length))
	$Multipliers.set_panel("Multiplier Chance", "%d%%" % Globals.round_data.tile_type_chance[E.TILE_TYPE.MULTIPLIER])
