extends Node

func _ready():
	Signals.connect("WordFound", _score_word)

func _score_word(word_tiles: WordTiles):
	# Update score
	var letter_score = 0
	for tile in word_tiles.tiles:
		letter_score += Globals.round_data.letter_scores.get(tile.letter)
	
	var length_mult = Globals.round_data.word_length_score_multiplier.get(word_tiles.word.length())
	if length_mult == null:
		# Not all lengths are tracked, so default to the highest defined
		var maxwl = Globals.round_data.word_length_score_multiplier.keys().max()
		var minwl = Globals.round_data.word_length_score_multiplier.keys().min()
		if word_tiles.word.length() > maxwl:
			length_mult = Globals.round_data.word_length_score_multiplier.get(maxwl)
		elif word_tiles.word.length() < minwl:
			length_mult = Globals.round_data.word_length_score_multiplier.get(minwl)
		else:
			length_mult = 1
	
	var tile_mult = 1
	for tile in word_tiles.tiles:
		if tile.tile_type == E.TILE_TYPE.MULTIPLIER: tile_mult *= 2
	
	var item_mult = ItemUtil.get_word_mult(word_tiles.word)
	
	var score_up = letter_score * length_mult * tile_mult * item_mult

	# Handle matched words
	if _is_select_win_type_valid(word_tiles.tiles):
		Globals.matched_words.append({"word": word_tiles.word, "score": score_up})
	
	# Handle life gain
	if Globals.game_type == E.GAME_TYPE.ATTACK:
		Globals.life = min(50, Globals.life + ItemUtil.get_word_heal(word_tiles.word))
	
	# Handle swap gain
	Globals.swaps = min(5, Globals.swaps + ItemUtil.get_extra_swaps(word_tiles.word))
	
	# Handle sound
	if score_up >= 100:
		Sounds.congrats()
	elif score_up >= 50:
		Sounds.yay()
	else:
		Sounds.pop()
	
	Signals.emit_signal("WordHandled", ScoreResults.new(word_tiles.word, word_tiles.tiles, score_up))

func _is_select_win_type_valid(tiles: Array) -> bool:
	# Check win types
	if Globals.round_data.win_type == E.WIN_TYPE.CONTAINS_SPECIAL:
		for tile in tiles:
			if tile.tile_type == E.TILE_TYPE.SPECIAL:
				return true
		return false
	elif Globals.round_data.win_type == E.WIN_TYPE.STARTS_SPECIAL:
		return tiles.front().tile_type == E.WIN_TYPE.STARTS_SPECIAL
	return true
