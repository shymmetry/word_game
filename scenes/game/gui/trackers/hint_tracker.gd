extends Panel

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	$"Margins/HBox/Value".text = str(Globals.hints)

func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		give_hint(Globals.level_data.min_word_length, 6)

func give_hint(min_size: int, max_size: int) -> void:
	if Globals.hints > 0:
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
			Globals.hints -= 1
			Signals.emit_signal("NotifyPlayer", "Hint: %s" % hint.word)

# Only finds words up to 6 characters for efficiency. I expect that if there is
# a word with 7+ letters we could also find one with less.
func _find_all_words(min_letters: int, max_letters: int = 6):
	var all_words = []
	for row in Globals.rows():
		for col in Globals.cols():
			var tile = Globals.tiles[row][col]
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
			tiles.append(Globals.tiles[row][col])
	return tiles
