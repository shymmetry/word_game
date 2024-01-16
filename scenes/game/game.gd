extends Control

func _init():
	if !Globals.level_data:
		Levels.set_current_level(0)
	
	Globals.swaps = Globals.level_data.starting_swaps
	Globals.score = 0
	Globals.progress = 0

func _ready():
	Signals.connect('StartGame', reset)
	Signals.connect('GameOver', game_over)

func _process(_delta):
	# Perform any necessary checks when the state of the board changes
	if Globals.board_changed:
		if has_won():
			if !UserData.completed_levels.has(str(Globals.current_level)):
				UserData.completed_levels[str(Globals.current_level)] = {}
			Sounds.win()
			$WinScreenCL.show()
			Store.save_game()
		if !find_all_words(Globals.level_data.min_word_length):
			$GameOverCL.show()
			Signals.emit_signal("GameOver")
		Globals.board_changed = false

func reset():
	$GameOverCL.hide()
	$WinScreenCL.hide()
	get_tree().reload_current_scene()

func has_won():
	if Globals.level_data.win_type == E.WIN_TYPE.NONE:
		return false
	else:
		return Globals.progress >= Globals.level_data.win_threshold

func game_over():
	Sounds.lose()
	if Globals.level_data.win_type == E.WIN_TYPE.NONE:
		var endless_data = UserData.completed_levels.get("0")
		if !endless_data:
			UserData.completed_levels["0"] = {"high_score": Globals.score}
			Store.save_game()
		elif Globals.score > endless_data.high_score:
			UserData.completed_levels["0"].high_score = Globals.score
			Store.save_game()

# Only finds words up to 6 characters for efficiency. I expect that if there is
# a word with 7+ letters we could also find one with less.
func find_all_words(min_letters: int, max_letters: int = 6):
	var all_words = []
	for col in Globals.level_data.cols:
		for row in Globals.level_data.rows:
			var tile = Globals.tiles[col][row]
			all_words += find_all_words_recurse(tile.letter, [tile], min_letters, max_letters)
	return all_words

func find_all_words_recurse(word: String, tiles: Array, min_letters: int, max_letters: int = 6):
	var all_words = []
	var last_tile = tiles.back()
	var adjacent_tiles = get_adjacent_tiles(last_tile)
	for tile in adjacent_tiles:
		if tiles.has(tile): 
			continue
		else:
			var new_word = word + tile.letter
			var new_tiles = tiles + [tile]
			
			# Check word
			if new_word.length() >= min_letters and Dict.is_word(new_word):
				all_words.append(WordTiles.new(new_word, new_tiles))
			
			# Recurse
			if new_word.length() < max_letters:
				all_words += find_all_words_recurse(new_word, new_tiles, min_letters, max_letters)
	
	return all_words

func get_adjacent_tiles(tile):
	var tiles = []
	for adjust in [[0,1],[0,-1],[1,0],[-1,0]]:
		var col = tile.col + adjust[0]
		var row = tile.row + adjust[1]
		if col >= 0 and col < Globals.level_data.cols \
				and row >= 0 and row < Globals.level_data.rows:
			tiles.append(Globals.tiles[col][row])
	return tiles

