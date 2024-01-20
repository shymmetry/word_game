extends Control

func _init():
	# Handle if loaded outside of menu
	# TODO: Only actually used for testing, figure out how to handle better
	if !Globals.game_mode:
		Store.load_game()
		Globals.game_mode = E.GAME_TYPE.ENDLESS
		Levels.set_endless()
	
	# Init game state
	Globals.swaps = Globals.level_data.starting_swaps
	Globals.hints = Globals.level_data.starting_hints
	Globals.score = 0
	Globals.last_processed_score_for_increased_difficulty = 0
	Globals.paused = false
	Globals.idle = true
	Globals.matched_words = []
	Globals.reset_seconds = Globals.level_data.time_seconds
	LetterUtil.set_letter_freq(Globals.level_data.letter_freq)

func _ready():
	Signals.connect("ResetGame", reset)
	Signals.connect("GameOver", game_over)
	Signals.connect("HintRequested", give_hint)
	Signals.connect("TimedOut", timed_out)
	Signals.connect("MatchedWord", increase_difficulty)
	
	Signals.emit_signal("StartGame")
	
	# Modify display based on mode
	if Globals.game_mode == E.GAME_TYPE.ENDLESS:
		$"Page/ScoreArea/HBoxContainer/Trackers/GoldTracker".hide()
		$"Page/ScoreArea/HBoxContainer/Trackers/LifeTracker".hide()
	elif Globals.game_mode == E.GAME_TYPE.SURVIVAL:
		pass

func _process(_delta):
	# Perform any necessary checks when the state of the board changes
	if Globals.board_changed:
		# Every time the board state changes and a hint was present, remove the
		# hint as it is considered outdated.
		if Globals.hint_tiles:
			Globals.hint_tiles = []
		
		Globals.board_changed = false

func reset():
	$GameOverModal.hide()
	$WinModal.hide()
	get_tree().reload_current_scene()

func timed_out():
	Globals.idle = false
	if Globals.game_mode == E.GAME_TYPE.ENDLESS:
		game_over()
	elif Globals.game_mode == E.GAME_TYPE.ENDLESS:
		round_over()

func round_over():
	pass

func game_over():
	Sounds.lose()
	$GameOverModal.show()
	if Globals.game_mode == E.GAME_TYPE.SURVIVAL:
		pass
	elif Globals.game_mode == E.GAME_TYPE.ENDLESS:
		if Globals.score > UserData.endless_high_score:
			UserData.endless_high_score = Globals.score
			Store.save_game()

func increase_difficulty():
	var last = Globals.last_processed_score_for_increased_difficulty
	var increases = Globals.score / Globals.points_to_increase_difficulty - last / Globals.points_to_increase_difficulty
	Globals.last_processed_score_for_increased_difficulty = Globals.score
	
	var new_reset_seconds = Globals.reset_seconds
	for _i in range(0, increases):
		if new_reset_seconds > 10:
			new_reset_seconds -= 1
	
	if new_reset_seconds != Globals.reset_seconds:
		Globals.reset_seconds = new_reset_seconds
		Signals.emit_signal("NotifyPlayer", "Refresh reduced to %d seconds" % new_reset_seconds)

func give_hint():
	if Globals.hints > 0:
		var min_size = Globals.min_word_length
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
			Signals.emit_signal("NotifyPlayer", "Hint: %s" % hint.word)

# Only finds words up to 6 characters for efficiency. I expect that if there is
# a word with 7+ letters we could also find one with less.
func find_all_words(min_letters: int, max_letters: int = 6):
	var all_words = []
	for col in Globals.cols:
		for row in Globals.rows:
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
		if col >= 0 and col < Globals.cols \
				and row >= 0 and row < Globals.rows:
			tiles.append(Globals.tiles[col][row])
	return tiles
