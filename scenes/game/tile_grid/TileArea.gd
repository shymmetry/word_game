extends Area2D

var exploding_tiles = []
var exploding_tiles_count = 0
var dropping_tiles_count = 0

func _ready():
	_init_tiles()
	Signals.connect('ExplodeFinished', _explode_finished)
	Signals.connect('DropFinished', _drop_finished)
	Signals.connect('WordGuess', _guess_word)
	Signals.connect('ResetBoard', _reset_board)

func _reset_board():
	Globals.idle = false
	var all_tiles = []
	for row in Globals.tiles: 
		for tile in row:
			if tile: all_tiles.append(tile)
	_remove_tiles(all_tiles)
	Globals.idle = true

func _init_tiles():
	Globals.tiles = []
	for row in range(0, Globals.rows()):
		var tile_row = []
		for col in range(0, Globals.cols()):
			if Globals.round_data.board[row][col] != '/':
				var tile = $TileCreator.create_tile(row, col, true)
				add_child(tile)
				tile_row.append(tile)
			else:
				tile_row.append(null)
			
		Globals.tiles.append(tile_row)

func _guess_word():
	var word = _get_word("", Globals.dragged_tiles)
	if word:
		var word_tiles = WordTiles.new(word, Globals.dragged_tiles)
		Signals.emit_signal("WordFound", word_tiles)
		_remove_tiles(word_tiles.tiles)
	else:
		Sounds.error()
		Globals.idle = true

# Returns the word starting with the given string and containing the given
# letter tiles as its next letters. If there is no word an empty string is returned.
func _get_word(word: String, tiles: Array[Tile]):
	const is_word = false
	for i in range(0, tiles.size()):
		var tile = tiles[i]
		var letter = tile.letter
		if letter != "?":
			word = word + letter
		else:
			for add_letter in Globals.all_letters:
				var final_word = _get_word(word + add_letter, tiles.slice(i+1, tiles.size()))
				if final_word:
					return final_word
			return null
	return word if Dict.is_word(word) else ""

func _remove_tiles(tiles: Array):
	# Remove all the points that were matched
	exploding_tiles = []; exploding_tiles_count = 0
	for tile in tiles:
		exploding_tiles.append(tile)
		exploding_tiles_count += 1
		tile.explode()

func _explode_finished():
	exploding_tiles_count -= 1
	if exploding_tiles_count == 0:
		# Remove exploded tiles
		for removed_tile in exploding_tiles:
			Globals.tiles[removed_tile.row][removed_tile.col] = null
		
		# Add tiles to top
		var new_tiles = _add_new_tiles(exploding_tiles)
		
		_drop_tiles(new_tiles)

func _add_new_tiles(removed_tiles: Array):
	# Adds new tiles for each given removed point. The created tiles are placed
	# in new negative y rows.
	var col_totals = []; col_totals.resize(Globals.cols()); col_totals.fill(0)
	for removed_tile in removed_tiles:
		col_totals[removed_tile.col] += 1
	
	var new_tiles = []
	for col in range(0, Globals.cols()):
		var new_tiles_col = []
		for row in range(0, col_totals[col]):
			var tile = $TileCreator.create_tile(row, col, false)
			add_child(tile)
			new_tiles_col.append(tile)
		
		new_tiles.append(new_tiles_col)
	
	return new_tiles

func _drop_tiles(new_tiles: Array):
	# Drop the tiles
	dropping_tiles_count = 0
	for col in range(0, Globals.cols()):
		# Go through backwards so the last rows drop first
		for row in range(Globals.rows()-1, -1, -1):
			var tile = Globals.tiles[row][col]
			var drop = _drop_size(row, col)
			
			if tile and drop > 0:
				tile.drop(drop)
				dropping_tiles_count += 1
				tile.row = row+drop
				Globals.tiles[row][col] = null
				Globals.tiles[row+drop][col] = tile
		
		# Drop the new tiles
		var new_tiles_col = new_tiles[col]
		for i in range(0, new_tiles_col.size()):
			var new_tile = new_tiles_col[i]
			var drop = _drop_size(-1-i, col)
			new_tile.drop(drop)
			dropping_tiles_count += 1
			
			var row = drop-1-i
			Globals.tiles[row][col] = new_tile
			
			new_tile.row = row

func _drop_size(row: int, col: int) -> int:
	if row == Globals.rows()-1: return 0
	var drop = 0
	var board = Globals.round_data.board
	for r in range(row+1, Globals.rows()):
		if r < 0:
			drop += 1
		# Handle permanently empty cells
		elif board[r][col] == '/':
			# If this spot would drop, the tile can pass through this spot
			# because it wont end in it.
			if _drop_size(r, col) > 0: 
				drop += 1
			else:
				break
		elif Globals.tiles[r][col] == null:
			drop += 1
		else:
			break
	return drop

func _drop_finished():
	dropping_tiles_count -= 1
	if dropping_tiles_count == 0:
		# Allow for actions
		Signals.emit_signal("BoardChanged")
		Globals.idle = true

func _print_tiles():
	for row in Globals.rows():
		var row_print = ""
		for col in Globals.cols():
			var letter = Globals.tiles[row][col].letter if Globals.tiles[row][col] else "/"
			row_print = row_print + letter + ","
		print(row_print)
