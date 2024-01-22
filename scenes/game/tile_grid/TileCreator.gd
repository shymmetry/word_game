extends Node

const tile_scene = preload("res://scenes/game/tile_grid/tile.tscn")

# Initial designated whether or not the tile is for the initial board state
func create_tile(col: int, row: int, initial: bool) -> Tile:
	var tile = tile_scene.instantiate()
	
	# Resolve positions
	var x = col * tile.size.x
	var y = 0
	if initial: y = row * tile.size.y
	else: y = -1 * (row+1) * tile.size.y
	tile.position = Vector2(x, y)
	
	tile.tile_type = _resolve_tile_type()
	tile.damage = _resolve_damage(initial)
	
	var rand_char = LetterUtil.rand_char()
	tile.set_letter(rand_char)
	tile.col = col
	tile.row = row
	
	return tile

func _resolve_tile_type():
	var rand_num = randi() % 100 + 1
	var sum = 0
	for tile_type in Globals.level_data.tile_type_chance:
		sum += Globals.level_data.tile_type_chance[tile_type]
		if sum >= rand_num:
			return tile_type
	return null

func _resolve_damage(initial: bool):
	if !initial: return 0
	var rand_num = randi() % 100 + 1
	var sum = 0
	for dmg in Globals.level_data.dmg_probs:
		sum += Globals.level_data.dmg_probs[dmg]
		if sum >= rand_num:
			return dmg
	return null
