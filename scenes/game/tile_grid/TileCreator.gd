extends Node

const tile_scene = preload("res://scenes/game/tile_grid/tile.tscn")

func create_tile(col: int, row: int, new: bool = false) -> Tile:
	var tile = tile_scene.instantiate()
	
	# Resolve positions
	var x = col * tile.size.x
	var y = 0
	if new: y = -1 * (row+1) * tile.size.y
	else: y = row * tile.size.y
	tile.position = Vector2(x, y)
	
	# Resolve tile type
	tile.tile_type = _resolve_tile_type()
	
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
