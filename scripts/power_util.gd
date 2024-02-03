extends Node

func wild(tile: Tile) -> bool:
	if Globals.energy < 5:
		return false
	
	tile.letter = "?"
	Globals.wild_selected = false
	Globals.selected_tile = null
	Globals.energy -= 5
	return true

func swap(tile1: Tile, tile2: Tile) -> bool:
	if Globals.energy < 2:
		return false
	Globals.energy -= 2
	
	var tile1_col = tile1.col; var tile1_row = tile1.row
	var tile1_position = tile1.position
	Globals.tiles[tile1_row][tile1_col] = tile2
	Globals.tiles[tile2.row][tile2.col] = tile1
	tile1.col = tile2.col; tile1.row = tile2.row
	tile2.col = tile1_col; tile2.row = tile1_row
	
	# Perform visual swap (prevent other actions while this is happening)
	var tween = create_tween()
	tween.tween_property(tile1, "position", tile2.position, 0.25)
	tween.parallel().tween_property(tile2, "position", tile1_position, 0.25)
	tween.tween_callback(func(): Globals.idle = true; Signals.emit_signal("BoardChanged"))
	
	return true

func hint(min_size: int, max_size: int) -> bool:
	if Globals.energy < 3:
		return false
	
	var hint_words = _find_all_words(min_size, max_size)
	var hints_by_length = {}
	# Sort the found words by their length
	for hint in hint_words:
		var word_len = hint.word.length()
		if hints_by_length.has(word_len):
			hints_by_length[word_len].append(hint)
		else:
			hints_by_length[word_len] = [hint]
	
	# Get a random word from the largest size word set
	var hint = null
	for word_len in range(max_size, min_size - 1, -1):
		if hints_by_length.has(word_len):
			var rand_i = randi() % hints_by_length.get(word_len).size()
			hint = hints_by_length.get(word_len)[rand_i]
			break
	
	if hint:
		Globals.hint_tiles = hint.tiles
		Globals.energy -= 3
		Signals.emit_signal("NotifyPlayer", "Hint: %s" % hint.word)
		return true
	else:
		return false

# Only finds words up to 6 characters for efficiency. I expect that if there is
# a word with 7+ letters we could also find one with less.
func _find_all_words(min_letters: int, max_letters: int = 6):
	var all_words = []
	for row in Globals.rows():
		for col in Globals.cols():
			var tile = Globals.tiles[row][col]
			if tile:
				all_words += _find_all_words_recurse(tile.letter, [tile], min_letters, max_letters)
	return all_words

func _find_all_words_recurse(word: String, tiles: Array, min_letters: int, max_letters: int = 6):
	var all_words = []
	var last_tile = tiles.back()
	var adjacent_tiles = _get_adjacent_tiles(last_tile)
	for tile in adjacent_tiles:
		if tiles.has(tile): # Ignore repeat tile usage
			continue
		else:
			var new_tiles = tiles + [tile]
			if tile.letter == "?": # Handle wildcard tiles
				for letter in Globals.all_letters:
					var new_word = word + letter
					all_words += _find_all_words_recurse_inner(new_word, new_tiles, min_letters, max_letters)
			else:
				var new_word = word + tile.letter
				all_words += _find_all_words_recurse_inner(new_word, new_tiles, min_letters, max_letters)
	
	return all_words

func _find_all_words_recurse_inner(word: String, tiles: Array, min_letters: int, max_letters: int = 6):
	var all_words = []
	# Check word
	if word.length() >= min_letters and Dict.is_word(word):
		all_words.append(WordTiles.new(word, tiles))
	
	# Recurse
	if word.length() < max_letters:
		all_words += _find_all_words_recurse(word, tiles, min_letters, max_letters)
	
	return all_words

func _get_adjacent_tiles(tile):
	var tiles = []
	for adjust in [[0,1],[0,-1],[1,0],[-1,0]]:
		var row = tile.row + adjust[0]
		var col = tile.col + adjust[1]
		if col >= 0 and col < Globals.cols() \
				and row >= 0 and row < Globals.rows():
			var new_tile = Globals.tiles[row][col]
			if new_tile:
				tiles.append(new_tile)
	return tiles
