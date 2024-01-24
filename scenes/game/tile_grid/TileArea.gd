extends Area2D

var exploding_tiles = []
var exploding_tiles_done = 0
var dropping_tiles_done = 0

func _ready():
	init_tiles()
	Signals.connect('ExplodeFinished', explode_finished)
	Signals.connect('DropFinished', drop_finished)
	Signals.connect('GuessWord', guess_word)
	Signals.connect('InitGame', init_tiles)
	
	# Center the tile area
	# For every missing row and column, adding 1/2 of the size of a tile
	# TODO: Fix magic numbers and do this more cleanly
	self.position = Vector2((6 - Globals.cols) * 35, (6 - Globals.rows) * 35)

func init_tiles():
	Globals.tiles = []
	for col in range(0, Globals.cols):
		var tile_col = []
		
		for row in range(0, Globals.rows):
			var tile = $TileCreator.create_tile(col, row, true)
			add_child(tile)
			tile_col.append(tile)
			
		Globals.tiles.append(tile_col)

func guess_word():
	var word = get_word("", Globals.dragged_tiles)
	if word:
		var word_tiles = WordTiles.new(word, Globals.dragged_tiles)
		Signals.emit_signal("WordFound", word_tiles)
		remove_word(word_tiles)
	else:
		Sounds.error()
		Globals.idle = true

func get_word(word: String, tiles: Array[Tile]):
	const is_word = false
	for i in range(0, tiles.size()):
		var tile = tiles[i]
		var letter = tile.letter
		if letter != "?":
			word = word + letter
		else:
			for add_letter in Globals.all_letters:
				var final_word = get_word(word + add_letter, tiles.slice(i+1, tiles.size()))
				if final_word:
					return final_word
			return null
	return word if Dict.is_word(word) else ""

func remove_word(word_tiles: WordTiles):
	if Globals.game_mode == E.GAME_TYPE.TIMED:
		Signals.emit_signal("ResetTimer")
	
	# Remove all the points that were matched
	exploding_tiles = []
	for tile in word_tiles.tiles:
		exploding_tiles.append(tile)
		exploding_tiles_done += 1
		tile.explode()

func explode_finished():
	exploding_tiles_done -= 1
	if exploding_tiles_done == 0:
		# Remove exploded tiles
		for removed_tile in exploding_tiles:
			Globals.tiles[removed_tile.col][removed_tile.row] = null
		
		# Add tiles to top
		var new_tiles = populate_tiles(exploding_tiles)
		
		drop_tiles(exploding_tiles, new_tiles)

func populate_tiles(removed_tiles: Array):
	# Adds new tiles for each given removed point. The created tiles are placed
	# in new negative y rows.
	var col_totals = []; col_totals.resize(Globals.cols); col_totals.fill(0)
	for removed_tile in removed_tiles:
		col_totals[removed_tile.col] += 1
	
	var new_tiles = []
	for col in Globals.cols:
		var new_tiles_col = []
		for row in range(0, col_totals[col]):
			var tile = $TileCreator.create_tile(col, row, false)
			add_child(tile)
			new_tiles_col.append(tile)
		
		new_tiles.append(new_tiles_col)
	
	return new_tiles

func drop_tiles(removed_tiles: Array, new_tiles: Array):
	# 2D array of the number of spaces each tile needs to drop
	var drops = []
	for i in range(0, Globals.cols):
		var col = []; col.resize(Globals.rows); col.fill(0)
		drops.append(col)
	
	# Calculate the number of spaces each tile must fall.
	for removed_tile in removed_tiles:
		# Drop every space above a removed point
		for y in range(0, removed_tile.row):
			drops[removed_tile.col][y] = drops[removed_tile.col][y] + 1
	
	# Drop the tiles
	dropping_tiles_done = 0
	for col in range(0, Globals.cols):
		# Go through backwards so the last rows drop first
		for row in range(Globals.rows-1, -1, -1):
			var drop = drops[col][row]
			var tile = Globals.tiles[col][row]
			
			if tile and drop > 0: 
				tile.drop(drop*tile.size.y)
				dropping_tiles_done += 1
				tile.row = row+drop
				Globals.tiles[col][row] = null
			Globals.tiles[col][row+drop] = tile
		
		# Drop the new tiles
		var new_tiles_col = new_tiles[col]
		for i in range(0, new_tiles_col.size()):
			var new_tile = new_tiles_col[i]
			new_tile.drop(new_tiles_col.size()*(new_tile.size.y))
			dropping_tiles_done += 1
			
			var row = new_tiles_col.size()-1-i
			Globals.tiles[col][new_tiles_col.size()-1-i] = new_tile
			
			new_tile.row = row

func drop_finished():
	dropping_tiles_done -= 1
	if dropping_tiles_done == 0:
		# Allow for actions
		Globals.board_changed = true
		Globals.idle = true
