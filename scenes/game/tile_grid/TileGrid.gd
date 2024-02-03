extends ReferenceRect

var clicked_tile = null
var last_hover_tile = null

# Handles all mouse input for the TileGrid
func _unhandled_input(event):
	# Handle mouse for putting down a tile
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and not event.pressed \
			and !Globals.round_over \
			and !Globals.paused:
		var end_tile = _get_tile_at_point(get_local_mouse_position())
		
		# Handle wild power
		if Globals.wild_selected:
			end_tile.letter = "?"
			Globals.wild_selected = false
			Globals.wilds -= 1
		
		# A tile was selected already for swapping
		if Globals.selected_tile:
			# Only handle if the tile to swap to was clicked and adjacent
			if end_tile and end_tile == clicked_tile \
					and _is_adjacent(Globals.selected_tile, end_tile) \
					and Globals.swaps > 0:
				_swap_tiles(Globals.selected_tile, end_tile)
				Sounds.swap()
			else:
				if Globals.selected_tile != end_tile:
					Sounds.error()
				Globals.idle = true
			Globals.selected_tile = null
		else:
			# A single tile was selected for swapping
			if end_tile == clicked_tile:
				Globals.selected_tile = end_tile
			# A different tile was selected for word guess
			else:
				if Globals.dragged_tiles.size() >= Globals.round_data.min_word_length and \
						(Globals.round_data.max_word_length == null or Globals.dragged_tiles.size() <= Globals.round_data.max_word_length):
					Signals.emit_signal("WordGuess")
				else:
					Sounds.error()
					Globals.idle = true
		clicked_tile = null; last_hover_tile = null; Globals.dragged_tiles = []
	
	# Handle mouse for clicking a tile
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed \
			and (Globals.idle or Globals.selected_tile) \
			and !Globals.round_over \
			and !Globals.wild_selected \
			and !Globals.paused:
		clicked_tile = _get_tile_at_point(get_local_mouse_position())
		Globals.idle = false
	
	# Handle mouse movement for dragging tiles
	if clicked_tile and event is InputEventMouseMotion and !Globals.selected_tile:
		var hover_tile = _get_tile_at_point(get_local_mouse_position())
		if hover_tile and hover_tile != last_hover_tile:
			last_hover_tile = hover_tile

			if hover_tile == clicked_tile and Globals.dragged_tiles.size() == 0:
				Globals.dragged_tiles.append(hover_tile)
			elif _is_adjacent(Globals.dragged_tiles.back(), hover_tile) \
					and !Globals.dragged_tiles.has(hover_tile):
				Globals.dragged_tiles.append(hover_tile)
			else:
				# If dragged to an invalid tile, clear
				Globals.dragged_tiles = []

func _swap_tiles(tile1, tile2):
	var tile1_col = tile1.col; var tile1_row = tile1.row
	var tile1_position = tile1.position
	Globals.tiles[tile1_row][tile1_col] = tile2
	Globals.tiles[tile2.row][tile2.col] = tile1
	tile1.col = tile2.col; tile1.row = tile2.row
	tile2.col = tile1_col; tile2.row = tile1_row
	Globals.swaps -= 1
	
	# Perform visual swap (prevent other actions while this is happening)
	var tween = create_tween()
	tween.tween_property(tile1, "position", tile2.position, 0.25)
	tween.parallel().tween_property(tile2, "position", tile1_position, 0.25)
	tween.tween_callback(func(): Globals.idle = true; Signals.emit_signal("BoardChanged"))

func _is_adjacent(tile1, tile2):
	if tile1 == null or tile2 == null: return false
	var coldif = abs(tile1.col - tile2.col)
	var rowdif = abs(tile1.row - tile2.row)
	return coldif + rowdif == 1

func _get_tile_at_point(pos):
	# TODO: Do something better than just getting the first tile.
	var tile = null
	for r in Globals.rows():
		if Globals.tiles[r][0]:
			tile = Globals.tiles[r][0]
			break

	var col = pos.x / tile.size.x
	var row = pos.y / tile.size.y
	
	if col < 0 or row < 0 or col >= Globals.cols() or row >= Globals.rows(): 
		return null
	else:
		return Globals.tiles[row][col]
