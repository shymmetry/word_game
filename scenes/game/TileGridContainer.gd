extends ReferenceRect

var clicked_tile = null
var last_hover_tile = null

# Handles all mouse input for the TileGrid
func _unhandled_input(event):
	# Handle mouse for putting down a tile
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and not event.pressed:
		var end_tile = get_tile_at_point(get_local_mouse_position())
		
		# A tile was selected already for swapping
		if Globals.selected_tile:
			# Only handle if the tile to swap to was clicked and adjacent
			if end_tile == clicked_tile \
					and is_adjacent(Globals.selected_tile, end_tile) \
					and Globals.swaps > 0:
				swap_tiles(Globals.selected_tile, end_tile)
			Globals.selected_tile = null
		else:
			# A single tile was selected for swapping
			if end_tile == clicked_tile:
				Globals.selected_tile = end_tile
			# A different tile was selected for word guess
			else:
				if Globals.dragged_tiles.size() >= Globals.level_data.min_word_length:
					Signals.emit_signal("GuessWord")
		clicked_tile = null; last_hover_tile = null; Globals.dragged_tiles = []
	
	# Handle mouse for clicking a tile
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed \
		and Globals.idle:
			clicked_tile = get_tile_at_point(get_local_mouse_position())
	
	# Handle mouse movement for dragging tiles
	if clicked_tile and event is InputEventMouseMotion:
		var hover_tile = get_tile_at_point(get_local_mouse_position())
		if hover_tile != last_hover_tile:
			last_hover_tile = hover_tile
			var samecol = hover_tile.col == clicked_tile.col
			var samerow = hover_tile.row == clicked_tile.row
			
			if samecol != samerow:
				var dragged_tiles = []
				for col in range(min(hover_tile.col, clicked_tile.col), max(hover_tile.col, clicked_tile.col) + 1):
					for row in range(min(hover_tile.row, clicked_tile.row), max(hover_tile.row, clicked_tile.row) + 1):
						dragged_tiles.append(Globals.tiles[col][row])
				Globals.dragged_tiles = dragged_tiles
			else:
				# If dragged to an invalid tile, clear
				Globals.dragged_tiles = []

func swap_tiles(tile1, tile2):
	var tile1_col = tile1.col; var tile1_row = tile1.row
	var tile1_position = tile1.position
	Globals.tiles[tile1_col][tile1_row] = tile2
	Globals.tiles[tile2.col][tile2.row] = tile1
	tile1.col = tile2.col; tile1.row = tile2.row
	tile2.col = tile1_col; tile2.row = tile1_row
	$"../ScoreArea".count_swap()
	
	# Perform visual swap (prevent other actions while this is happening)
	Globals.idle = false
	var tween = create_tween()
	tween.tween_property(tile1, "position", tile2.position, 0.25)
	tween.parallel().tween_property(tile2, "position", tile1_position, 0.25)
	tween.tween_callback(func(): Globals.idle = true)

func is_adjacent(tile1, tile2):
	var coldif = abs(tile1.col - tile2.col)
	var rowdif = abs(tile1.row - tile2.row)
	return coldif + rowdif == 1

func get_tile_at_point(position):
	var col = floor((position.x-Globals.level_data.padding/2) / (Globals.level_data.tile_size+Globals.level_data.padding))
	var row = floor((position.y-Globals.level_data.padding/2) / (Globals.level_data.tile_size+Globals.level_data.padding))
	return Globals.tiles[min(col, Globals.level_data.cols-1)][min(row, Globals.level_data.rows-1)]
