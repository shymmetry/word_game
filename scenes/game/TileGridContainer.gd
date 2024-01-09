extends ReferenceRect

var lifted = null
var lifted_point = null
var lifted_position = null
var swap_tile = null
var swap_position = null
var swap_direction = null

# Handles all mouse input for the TileGrid
func _unhandled_input(event):
	# Handle mouse for putting down a tile
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and not event.pressed:
		# If there is a swap tile perform the swap. Else just clear.
		if swap_tile: 
			var xdif = get_local_mouse_position().x - lifted_point.x
			var ydif = get_local_mouse_position().y - lifted_point.y
			var max_dif = max(abs(xdif), abs(ydif))
			var min_dist = (Globals.level_data.tile_size + Globals.level_data.padding) / 2
			if max_dif > min_dist:
				var lifted_col = lifted.col
				var lifted_row = lifted.row
				Globals.tiles[lifted_col][lifted_row] = swap_tile
				Globals.tiles[swap_tile.col][swap_tile.row] = lifted
				lifted.col = swap_tile.col; lifted.row = swap_tile.row
				swap_tile.col = lifted_col; swap_tile.row = lifted_row
				lifted.position = swap_position
				swap_tile.position = lifted_position
				$"../ScoreArea".count_swap()
				Signals.emit_signal("FindAndRemoveWords")
			else:
				lifted.position = lifted_position
				swap_tile.position = swap_position
		lifted = null; lifted_point = null; lifted_position = null
		swap_tile = null; swap_position = null; swap_direction = null
	
	# Handle mouse for picking up a tile
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		var can_swap = Globals.idle and Globals.swaps > 0
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and can_swap:
			lifted_point = get_local_mouse_position()
			lifted = get_tile_at_point(lifted_point)
			lifted_position = lifted.position
	
	# Handle mouse movement for dragging tiles
	if lifted and event is InputEventMouseMotion:
		var xdif = get_local_mouse_position().x - lifted_point.x
		var ydif = get_local_mouse_position().y - lifted_point.y
		if abs(xdif) > abs(ydif):
			if xdif > 0: #right
				if lifted.col == Globals.level_data.cols - 1: return
				if swap_direction != "right":
					swap_direction = "right"
					if swap_tile:
						swap_tile.position = swap_position
					swap_tile = Globals.tiles[lifted.col+1][lifted.row]
					swap_position = swap_tile.position
			else: #left
				if lifted.col == 0: return
				if swap_direction != "left":
					swap_direction = "left"
					if swap_tile:
						swap_tile.position = swap_position
					swap_tile = Globals.tiles[lifted.col-1][lifted.row]
					swap_position = swap_tile.position
			var move = min(abs(xdif), Globals.level_data.tile_size + Globals.level_data.padding) * sign(xdif)
			lifted.position.x = lifted_position.x + move
			lifted.position.y = lifted_position.y
			swap_tile.position.x = swap_position.x - move
		else:
			if ydif > 0: #down
				if lifted.row == Globals.level_data.rows - 1: return
				if swap_direction != "down":
					swap_direction = "down"
					if swap_tile:
						swap_tile.position = swap_position
					swap_tile = Globals.tiles[lifted.col][lifted.row+1]
					swap_position = swap_tile.position
			else: #up
				if lifted.row == 0: return
				if swap_direction != "up":
					swap_direction = "up"
					if swap_tile:
						swap_tile.position = swap_position
					swap_tile = Globals.tiles[lifted.col][lifted.row-1]
					swap_position = swap_tile.position
			var move = min(abs(ydif), Globals.level_data.tile_size + Globals.level_data.padding) * sign(ydif)
			lifted.position.x = lifted_position.x
			lifted.position.y = lifted_position.y + move
			swap_tile.position.y = swap_position.y - move

func get_tile_at_point(position):
	var col = floor((position.x-Globals.level_data.padding/2) / (Globals.level_data.tile_size+Globals.level_data.padding))
	var row = floor((position.y-Globals.level_data.padding/2) / (Globals.level_data.tile_size+Globals.level_data.padding))
	assert(col < Globals.level_data.cols and row < Globals.level_data.rows)
	return Globals.tiles[col][row]
