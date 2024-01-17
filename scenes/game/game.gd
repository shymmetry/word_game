extends Control

func _init():
	if !Globals.level_data:
		Levels.set_current_level(0)
	
	Globals.swaps = Globals.level_data.starting_swaps
	Globals.hints = Globals.level_data.starting_hints
	Globals.score = 0
	Globals.progress = 0

func _ready():
	Signals.connect('StartGame', reset)
	Signals.connect('GameOver', game_over)
	Signals.connect('HintRequested', give_hint)

func _process(_delta):
	# Perform any necessary checks when the state of the board changes
	if Globals.board_changed:
		# Handle win/loss
		if has_won():
			if !UserData.completed_levels.has(str(Globals.current_level)):
				UserData.completed_levels[str(Globals.current_level)] = {}
			Sounds.win()
			$WinModal.show()
			Store.save_game()
		if !find_all_words(Globals.level_data.min_word_length):
			Signals.emit_signal("GameOver")
		
		# Every time the board state changes and a hint was present, remove the
		# hint as it is considered outdated.
		if Globals.hint_tiles:
			Globals.hint_tiles = []
		
		Globals.board_changed = false

func reset():
	$GameOverModal.hide()
	$WinModal.hide()
	get_tree().reload_current_scene()

func has_won():
	if Globals.level_data.win_type == E.WIN_TYPE.NONE:
		return false
	else:
		return Globals.progress >= Globals.level_data.win_threshold

func game_over():
	Sounds.lose()
	$GameOverModal.show()
	if Globals.level_data.win_type == E.WIN_TYPE.NONE:
		var endless_data = UserData.completed_levels.get("0")
		if !endless_data:
			UserData.completed_levels["0"] = {"high_score": Globals.score}
			Store.save_game()
		elif Globals.score > endless_data.high_score:
			UserData.completed_levels["0"].high_score = Globals.score
			Store.save_game()

func give_hint():
	if Globals.hints > 0:
		var min_size = Globals.level_data.min_word_length
		var max_size = 6
		var hint_words = find_all_words(min_size, max_size)
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

# Only finds words up to 6 characters for efficiency. I expect that if there is
# a word with 7+ letters we could also find one with less.
func find_all_words(min_letters: int, max_letters: int = 6):
	var all_words = []
	for col in Globals.level_data.cols:
		for row in Globals.level_data.rows:
			var tile = Globals.tiles[col][row]
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
		var col = tile.col + adjust[0]
		var row = tile.row + adjust[1]
		if col >= 0 and col < Globals.level_data.cols \
				and row >= 0 and row < Globals.level_data.rows:
			tiles.append(Globals.tiles[col][row])
	return tiles

