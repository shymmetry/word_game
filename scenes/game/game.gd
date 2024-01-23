extends Control

func _init():
	# Handle if loaded outside of menu
	# TODO: Only actually used for testing, figure out how to handle better
	if Globals.game_mode == null:
		Store.load_game()
		Globals.game_mode = E.GAME_TYPE.SURVIVAL
		Levels.set_current_round(1)
	
	# Init game state
	Globals.score = 0
	Globals.swaps = Globals.level_data.swaps
	Globals.hints = Globals.level_data.hints
	if Globals.game_mode == E.GAME_TYPE.SURVIVAL:
		Globals.life = Globals.level_data.life
	
	_init_round()

func _init_round():
	Globals.paused = false
	Globals.idle = true
	LetterUtil.set_letter_freq(Globals.level_data.letter_freq)
	Globals.last_processed_score_for_increased_difficulty = 0
	Globals.reset_seconds = Globals.level_data.time_seconds
	Globals.matched_words = []

func _ready():
	Signals.connect("ResetGame", reset)
	Signals.connect("GameOver", game_over)
	Signals.connect("TimedOut", timed_out)
	Signals.connect("NextRound", next_round)
	
	Signals.emit_signal("StartGame")
	
	# Modify display based on mode
	if Globals.game_mode == E.GAME_TYPE.ENDLESS:
		$Page/HUD/HBoxContainer/Trackers/GoldTracker.hide()
		$Page/HUD/HBoxContainer/Trackers/LifeTracker.hide()
		$Page/HUD/HBoxContainer/Trackers/TimeTracker.hide()
		$Page/Title/TimerLabel.hide()
	elif Globals.game_mode == E.GAME_TYPE.TIMED:
		$Page/HUD/HBoxContainer/Trackers/GoldTracker.hide()
		$Page/HUD/HBoxContainer/Trackers/LifeTracker.hide()
	elif Globals.game_mode == E.GAME_TYPE.SURVIVAL:
		$Page/HUD/HBoxContainer/Trackers/ScoreTracker.hide()

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
	get_tree().reload_current_scene()

func timed_out():
	Globals.idle = false
	if Globals.game_mode == E.GAME_TYPE.TIMED:
		game_over()
	elif Globals.game_mode == E.GAME_TYPE.SURVIVAL:
		round_over()

func round_over():
	Globals.idle = false
	Signals.emit_signal("RoundOver")
	
	var start_pos = $Page/PlayArea.position
	var tween = create_tween()
	tween.tween_property($Page/PlayArea, "position", start_pos + Vector2(0, 500), 1)
	tween.tween_callback(func(): $Page/PlayArea/TileGrid.hide())
	tween.tween_callback(func(): $Page/PlayArea/Shop.show())
	tween.tween_property($Page/PlayArea, "position", start_pos, 1)

func next_round():
	_init_round()
	Signals.emit_signal("InitGame")
	
	var start_pos = $Page/PlayArea.position
	var tween = create_tween()
	tween.tween_property($Page/PlayArea, "position", start_pos + Vector2(0, 500), 1)
	tween.tween_callback(func(): $Page/PlayArea/Shop.hide())
	tween.tween_callback(func(): $Page/PlayArea/TileGrid.show())
	tween.tween_property($Page/PlayArea, "position", start_pos, 1)
	
	Signals.emit_signal("StartGame")

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
