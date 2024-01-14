extends Control

func _ready():
	if Globals.current_level == 0:
		$Title.text = "Endless"
	else:
		$Title.text = "Level %s" % Globals.current_level
	$"Trackers/SwapTracker".set_icon("res://icons/outline_swap_horiz_white_24dp.png")
	$"Trackers/ScoreTracker".set_icon("res://icons/outline_stars_white_36dp.png")
	
	if Globals.level_data.win_type == E.WIN_TYPE.NONE:
		$Progress.hide()

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	$"Trackers/SwapTracker".set_value(Globals.swaps)
	$"Trackers/ScoreTracker".set_value(Globals.score)
	$"Progress/Goal".text = Globals.level_data.goal
	$"Progress/ProgressBar".max_value = Globals.level_data.win_threshold
	$"Progress/ProgressBar".value = Globals.progress

func score_word(word: String):
	# Update score
	var letter_score_up = 0
	for letter in word:
		letter_score_up += Globals.level_data.letter_scores.get(letter)
	var length_mult = Globals.level_data.word_length_score_multiplier.get(word.length())
	if length_mult == null:
		# Not all lengths are tracked, so default to the highest defined
		var maxwl = Globals.level_data.word_length_score_multiplier.keys().max()
		var minwl = Globals.level_data.word_length_score_multiplier.keys().min()
		if word.length() > maxwl:
			length_mult = Globals.level_data.word_length_score_multiplier.get(maxwl)
		elif word.length() < minwl:
			length_mult = Globals.level_data.word_length_score_multiplier.get(minwl)
		else:
			length_mult = 1
	var score_up = letter_score_up * length_mult
	Globals.score += score_up
	
	# Update swap count
	var bonus = Globals.level_data.swap_bonus.get(word.length())
	if bonus == null:
		# Not all lengths are tracked, so default to the highest defined
		var maxwl = Globals.level_data.swap_bonus.keys().max()
		var minwl = Globals.level_data.swap_bonus.keys().min()
		if word.length() > maxwl:
			bonus = Globals.level_data.swap_bonus.get(maxwl)
		elif word.length() < minwl:
			bonus = Globals.level_data.swap_bonus.get(minwl)
		else:
			bonus = 0
	Globals.swaps += bonus
	
	Globals.matched_words = [word] + Globals.matched_words
	
	track_progress(word, score_up)
	
	return score_up

func track_progress(word: String, score_up: int):
	match Globals.level_data.win_type:
		E.WIN_TYPE.SCORE:
			Globals.progress += score_up
		E.WIN_TYPE.WORD_SIZE:
			if word.length() >= Globals.level_data.win_data.word_size:
				Globals.progress += 1

func count_swap():
	Globals.swaps -= 1

func _on_in_game_menu_button_pressed():
	$"../MenuCL".show()

func _on_give_up_pressed():
	$"../GiveUpCL".show()