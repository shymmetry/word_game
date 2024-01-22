extends Control

func _init():
	# Handle if loaded outside of menu
	# TODO: Only actually used for testing, figure out how to handle better
	if Globals.game_mode == null:
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
	Signals.connect("TimedOut", timed_out)
	
	Signals.emit_signal("StartGame")
	
	# Modify display based on mode
	if Globals.game_mode == E.GAME_TYPE.ENDLESS:
		$Page/HUD/HBoxContainer/Trackers/GoldTracker.hide()
		$Page/HUD/HBoxContainer/Trackers/LifeTracker.hide()
		$Page/Title/TimerLabel.hide()
	elif Globals.game_mode == E.GAME_TYPE.TIMED:
		$Page/HUD/HBoxContainer/Trackers/GoldTracker.hide()
		$Page/HUD/HBoxContainer/Trackers/LifeTracker.hide()
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
	if Globals.game_mode == E.GAME_TYPE.TIMED:
		game_over()
	elif Globals.game_mode == E.GAME_TYPE.SURVIVAL:
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
	elif Globals.game_mode == E.GAME_TYPE.TIMED:
		if Globals.score > UserData.timed_high_score:
			UserData.timed_high_score = Globals.score
			Store.save_game()
