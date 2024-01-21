extends Area2D

const tile_scene = preload("res://scenes/game/tile_grid/tile.tscn")
const word_pop = preload("res://scenes/game/word_pop/word_pop.tscn")

var exploding_tiles = []
var exploding_tiles_done = 0
var dropping_tiles_done = 0

func _ready():
	init_tiles()
	Signals.connect('ExplodeFinished', explode_finished)
	Signals.connect('DropFinished', drop_finished)
	Signals.connect('GuessWord', guess_word)

func init_tiles():
	Globals.tiles = []
	for col in range(0, Globals.cols):
		var tile_col = []
		
		for row in range(0, Globals.rows):
			var tile = create_tile(col, row)
			tile_col.append(tile)
			
		Globals.tiles.append(tile_col)

func guess_word():
	var word = get_word("", Globals.dragged_tiles)
	if word:
		remove_word(WordTiles.new(word, Globals.dragged_tiles))
	else:
		Sounds.failure()
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
	var score_results = score_word(word_tiles)
	
	# Handle sound
	if score_results.score >= 100:
		Sounds.congrats()
	elif score_results.score >= 50:
		Sounds.yay()
	else:
		Sounds.pop()
	
	if Globals.game_mode == E.GAME_TYPE.ENDLESS:
		Signals.emit_signal("ResetTimer")
	
	# Handle word pop
	var new_word_pop = word_pop.instantiate()
	new_word_pop.update_text(score_results)
	var center = center_of_points(word_tiles.tiles)
	new_word_pop.set_position(center)
	
	add_child(new_word_pop)
	
	Signals.emit_signal("MatchedWord")
	
	# Remove all the points that were matched
	exploding_tiles = []
	for tile in word_tiles.tiles:
		exploding_tiles.append(tile)
		exploding_tiles_done += 1
		tile.explode()

func score_word(word_tiles: WordTiles) -> ScoreResults:
	# Update score
	var letter_score = 0
	for tile in word_tiles.tiles:
		letter_score += Globals.level_data.letter_scores.get(tile.letter)
	
	var length_mult = Globals.level_data.word_length_score_multiplier.get(word_tiles.word.length())
	if length_mult == null:
		# Not all lengths are tracked, so default to the highest defined
		var maxwl = Globals.level_data.word_length_score_multiplier.keys().max()
		var minwl = Globals.level_data.word_length_score_multiplier.keys().min()
		if word_tiles.word.length() > maxwl:
			length_mult = Globals.level_data.word_length_score_multiplier.get(maxwl)
		elif word_tiles.word.length() < minwl:
			length_mult = Globals.level_data.word_length_score_multiplier.get(minwl)
		else:
			length_mult = 1
	
	var tile_mult = 1
	for tile in word_tiles.tiles:
		if tile.tile_type == E.TILE_TYPE.MULTIPLIER: tile_mult *= 2
	
	var score_up = letter_score * length_mult * tile_mult
	Globals.score += score_up
	
	# Update bonuses
	var swap_bonus = Globals.level_data.swap_bonus.get(word_tiles.word.length())
	if swap_bonus == null:
		# Not all lengths are tracked, so default to the highest defined
		var maxwl = Globals.level_data.swap_bonus.keys().max()
		var minwl = Globals.level_data.swap_bonus.keys().min()
		if word_tiles.word.length() > maxwl:
			swap_bonus = Globals.level_data.swap_bonus.get(maxwl)
		elif word_tiles.word.length() < minwl:
			swap_bonus = Globals.level_data.swap_bonus.get(minwl)
		else:
			swap_bonus = 0
	Globals.swaps += swap_bonus
	
	Globals.matched_words.append({"word": word_tiles.word, "score": score_up})
	
	return ScoreResults.new(score_up, swap_bonus, 0, 0)

func center_of_points(tiles: Array[Tile]):
	var minx = 9999999
	var maxx = 0
	var miny = 9999999
	var maxy = 0
	var size = tiles[0].size
	for tile in tiles:
		minx = min(minx, tile.global_position.x)
		maxx = max(maxx, tile.global_position.x)
		miny = min(miny, tile.global_position.y)
		maxy = max(maxy, tile.global_position.y)
	
	var x = minx+(maxx-minx)/2+size.x/2
	var y = miny+(maxy-miny)/2+size.y/2
	
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
			var tile = create_tile(col, row, true)
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

func create_tile(col: int, row: int, new: bool = false):
	var tile = tile_scene.instantiate()
	
	# Resolve positions
	var x = col * tile.size.x
	var y = 0
	if new: y = -1 * (row+1) * tile.size.y
	else: y = row * tile.size.y
	tile.position = Vector2(x, y)
	
	# Resolve tile type
	tile.tile_type = resolve_tile_type()
	
	var rand_char = LetterUtil.rand_char()
	tile.set_letter(rand_char)
	tile.col = col
	tile.row = row

	add_child(tile)
	return tile

func resolve_tile_type():
	var rand_num = randi() % 100 + 1
	var sum = 0
	for tile_type in Globals.level_data.tile_type_chance:
		sum += Globals.level_data.tile_type_chance[tile_type]
		if sum >= rand_num:
			return tile_type
	return null
