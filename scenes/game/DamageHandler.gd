extends Node

func take_damage():
	var total_damage = 0
	for tile_col in Globals.tiles:
		for tile in tile_col:
			total_damage += tile.damage
	
	Globals.life -= total_damage
	if Globals.life <= 0:
		Signals.emit_signal("GameOver")
