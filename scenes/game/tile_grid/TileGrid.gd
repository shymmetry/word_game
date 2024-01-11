extends Area2D

const tile_scene = preload("res://scenes/game/tile_grid/tile.tscn")
const word_pop = preload("res://scenes/game/word_pop/word_pop.tscn")
const ED = preload("res://scripts/dict.gd")
const LU = preload("res://scripts/letters.gd")

var letter_util = null
var word_dict = null
var store = null

var exploding_tiles = {}
var exploding_tiles_done = 0
var dropping_tiles_done = 0

func _init():
	if !Globals.level_data:
		Levels.set_current_level(1)
	
	Globals.swaps = Globals.level_data.starting_swaps
	Globals.score = 0
	
	letter_util = LU.new()
	word_dict = ED.new()
	store = Store.new()

func _ready():
	init_tiles()
	Signals.connect('ExplodeFinished', explode_finished)
	Signals.connect('DropFinished', drop_finished)
	Signals.connect('StartGame', reset)
	Signals.connect('GuessWord', guess_word)

func _process(_delta):
	# Perform any necessary checks when the state of the board changes
	if Globals.board_changed:
		if has_won():
			if !UserData.completed_levels.has(Globals.current_level):
				UserData.completed_levels[Globals.current_level] = {}
			$"../../WinScreenCL".show()
			store.save_game()
		elif Globals.swaps <= 0 \
				and get_all_line_words().size() == 0 \
				and Globals.level_data.word_drag_type == E.WORD_DRAG.LINE:
			$"../../GameOverCL/GameOver/VBoxContainer/Score".text = "Score: %s" % Globals.score
			$"../../GameOverCL".show()
		Globals.board_changed = false

func has_won():
	match Globals.level_data.win_type:
		E.WIN_TYPES.SCORE:
			return Globals.score >= Globals.level_data.win_threshold
	return false

func init_tiles():
	Globals.tiles = []
	for col in range(0, Globals.level_data.cols):
		var tile_col = []
		
		for row in range(0, Globals.level_data.rows):
			var tile = create_tile(col, row)
			tile_col.append(tile)
			
		Globals.tiles.append(tile_col)

func reset():
	$"../../GameOverCL".hide()
	$"../../WinScreenCL".hide()
	get_tree().reload_current_scene()

func guess_word():
	var word1 = ""; var word2 = ""
	for tile in Globals.dragged_tiles:
		var letter = tile.get_node("Letter").text
		word1 = word1 + letter
		word2 = letter + word2
	
	if word_dict.is_word(word1):
		remove_words([{"str": word1, "tiles": Globals.dragged_tiles}])
	elif word_dict.is_word(word2):
		remove_words([{"str": word2, "tiles": Globals.dragged_tiles}])

func remove_words(words_to_remove):
	exploding_tiles = {}
	for word in words_to_remove:
		var score = $"../../ScoreArea".score_word(word.str)
		
		var new_word_pop = word_pop.instantiate()
		new_word_pop.update_text(word.str, score)
		# Need to add the parents position since the CanvasLayer of the 
		# word_pop doesn't have (0,0) as it's parents position
		var center = center_of_points(word.tiles)
		var parent_pos = get_parent().position
		new_word_pop.set_position(center + parent_pos)
		
		add_child(new_word_pop)
		
		for tile in word.tiles:
			exploding_tiles[tile] = null
	
	# Remove all the points that were matched
	for tile in exploding_tiles:
		tile.explode()
		exploding_tiles_done += 1

func center_of_points(tiles):
	var tile1 = tiles[0]
	var tile2 = tiles[tiles.size()-1]
	# Get the average of the first and last nodes to get the middle. Add
	# 1 to center the point.
	# Subtract half of size from the end to center
	# Add half of padding to account for sides of tile grid
	var x = (abs(tile1.col+tile2.col+1)/2.0)*(Globals.level_data.tile_size+Globals.level_data.padding)-40+Globals.level_data.padding/2
	var y = (abs(tile1.row+tile2.row+1)/2.0)*(Globals.level_data.tile_size+Globals.level_data.padding)-20+Globals.level_data.padding/2
	return Vector2(x, y)

func explode_finished():
	exploding_tiles_done -= 1
	if exploding_tiles_done == 0:
		# Remove exploded tiles
		for removed_tile in exploding_tiles:
			Globals.tiles[removed_tile.col][removed_tile.row] = null
		
		# Add tiles to top
		var new_tiles = populate_tiles(exploding_tiles)
		
		drop_tiles(exploding_tiles, new_tiles)

func populate_tiles(removed_tiles):
	# Adds new tiles for each given removed point. The created tiles are placed
	# in new negative y rows.
	var col_totals = []; col_totals.resize(Globals.level_data.cols); col_totals.fill(0)
	for removed_tile in removed_tiles:
		col_totals[removed_tile.col] += 1
	
	var new_tiles = []
	for col in Globals.level_data.cols:
		var new_tiles_col = []
		for row in range(0, col_totals[col]):
			var tile = create_tile(col, row, true)
			new_tiles_col.append(tile)
		
		new_tiles.append(new_tiles_col)
	
	return new_tiles

func drop_tiles(removed_tiles: Dictionary, new_tiles: Array):
	# 2D array of the number of spaces each tile needs to drop
	var drops = []
	for i in range(0, Globals.level_data.cols):
		var col = []; col.resize(Globals.level_data.rows); col.fill(0)
		drops.append(col)
	
	# Calculate the number of spaces each tile must fall.
	for removed_tile in removed_tiles:
		# Drop every space above a removed point
		for y in range(0, removed_tile.row):
			drops[removed_tile.col][y] = drops[removed_tile.col][y] + 1
	
	# Drop the tiles
	dropping_tiles_done = 0
	for col in range(0, Globals.level_data.cols):
		for row in range(Globals.level_data.rows-1, -1, -1):
			var drop = drops[col][row]
			var tile = Globals.tiles[col][row]
			
			if tile and drop > 0: 
				tile.drop(drop*(Globals.level_data.tile_size+Globals.level_data.padding))
				dropping_tiles_done += 1
				tile.row = row+drop
				Globals.tiles[col][row] = null
			Globals.tiles[col][row+drop] = tile
		
		var new_tiles_col = new_tiles[col]
		for i in range(0, new_tiles_col.size()):
			var new_tile = new_tiles_col[i]
			new_tile.drop(new_tiles_col.size()*(Globals.level_data.tile_size+Globals.level_data.padding))
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

func get_all_line_words():
	# Gets all the words on the board starting from any letter 
	var found = []
	for col in range(0, Globals.level_data.cols):
		for row in range(0, Globals.level_data.rows):
			for dif in [[1,0],[-1,0],[0,1],[0,-1]]:
				var word = get_word(row, col, dif[0], dif[1])
				if word: found.append(word)
	return found

func get_word(x: int, y: int, xdif: int, ydif: int):
	# Gets the longest word starting at a given point and going in a given 
	# direction. If no word is found null is returned.
	var letters = ""
	var word_tiles = []
	var xrange 
	var yrange
	match xdif:
		-1: xrange = range(x, -1, -1)
		0: xrange = [x]
		1: xrange = range(x, Globals.level_data.cols)
	match ydif:
		-1: yrange = range(y, -1, -1)
		0: yrange = [y]
		1: yrange = range(y, Globals.level_data.rows)
	for col in xrange:
		for row in yrange:
			letters += get_letter(col, row)
	
	var longest_str = get_longest_word(letters)
	if !longest_str: return null
	
	for i in range(0, longest_str.length()):
		word_tiles.append(Globals.tiles[x+(i*xdif)][y+(i*ydif)])
	return {"str": longest_str, "tiles": word_tiles}

func get_letter(x: int, y: int):
	return Globals.tiles[x][y].get_node("Letter").text

func get_longest_word(letters: String):
	if letters.length() < Globals.level_data.min_word_length: return null
	for length in range(letters.length(), Globals.level_data.min_word_length-1, -1):
		var word = letters.substr(0, length)
		if word_dict.is_word(word):
			return word
	return null

func create_tile(col: int, row: int, new: bool = false):
	var tile = tile_scene.instantiate()
	
	var x = Globals.level_data.padding*(col + 1) + col*Globals.level_data.tile_size
	var y = 0
	if new: y = -1 * (Globals.level_data.padding*(row) + (row + 1)*Globals.level_data.tile_size)
	else: y = Globals.level_data.padding*(row + 1) + row*Globals.level_data.tile_size
	
	tile.position = Vector2(x, y)
	var rand_char = letter_util.rand_char()
	tile.get_node("Letter").text = rand_char
	tile.get_node("Score").text = str(Globals.level_data.letter_scores.get(rand_char))
	tile.col = col
	tile.row = row

	add_child(tile)
	return tile

func print_tiles():
	var tile_letters = []
	for col in range(0, Globals.level_data.cols):
		var tile_letters_col = []
		for row in range(0, Globals.level_data.rows):
			tile_letters_col.append(get_letter(col, row))
		tile_letters.append(tile_letters_col)
	print(tile_letters)
