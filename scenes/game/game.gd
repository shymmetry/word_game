extends Control

func _init():
	# Handle if loaded outside of menu
	# TODO: Only actually used for testing, figure out how to handle better
	if Globals.current_round == 0:
		Store.load_game()
		Levels.set_current_round(1)
	
	# Init game state
	Globals.score = 0
	Globals.items = {}
	Globals.swaps = Globals.round_data.swaps
	Globals.hints = Globals.round_data.hints
	Globals.seconds_left = 0
	
	_init_round()

func _init_round():
	Globals.paused = false
	Globals.idle = true
	LetterUtil.set_letter_freq(Globals.round_data.letter_freq)
	Globals.seconds_left += Globals.round_data.time_seconds
	Globals.matched_words = []

func _ready():
	Signals.connect("ResetGame", _reset)
	Signals.connect("GameOver", _game_over)
	Signals.connect("TimedOut", _timed_out)
	Signals.connect("NextRound", _next_round)
	Signals.connect("BoardChanged", _on_board_changed)
	
	# TODO: Check to see if this actually triggers since its called from a _ready
	# function. Could have issues since the connectors instantiate in ready functions too.
	Signals.emit_signal("StartRound")

func _on_board_changed():
	# Every time the board state changes and a hint was present, remove the
	# hint as it is considered outdated.
	if Globals.hint_tiles:
		Globals.hint_tiles = []
	
	# Check if the round has been won
	

func _reset():
	Levels.set_current_round(1)
	get_tree().reload_current_scene()

func _timed_out():
	Globals.idle = false
	_game_over()

func _round_over():
	Globals.idle = false
	Globals.matched_words = []
	Signals.emit_signal("RoundOver")
	
	if Globals.current_round == Levels.total_rounds():
		$WinModal.show()
		return
	
	var start_pos = $Page/PlayArea.position
	var tween = create_tween()
	tween.tween_property($Page/PlayArea, "position", start_pos + Vector2(0, 500), 1)
	tween.tween_callback(func(): $Page/PlayArea/TileGrid.hide())
	tween.tween_callback(func(): $Page/PlayArea/Shop.show())
	tween.tween_property($Page/PlayArea, "position", start_pos, 1)

func _next_round():
	Levels.set_current_round(Globals.current_round + 1)
	_init_round()
	
	# Reset the grid
	var scene = load("res://scenes/game/tile_grid/tile_grid.tscn")
	var old_grid = $Page/PlayArea/TileGrid
	$Page/PlayArea.remove_child(old_grid)
	old_grid.queue_free()
	var new_grid = scene.instantiate()
	new_grid.hide()
	$Page/PlayArea.add_child(new_grid, true)
	
	# Swap the Play Area content
	var start_pos = $Page/PlayArea.position
	var tween = create_tween()
	tween.tween_property($Page/PlayArea, "position", start_pos + Vector2(0, 500), 1)
	tween.tween_callback(func(): $Page/PlayArea/Shop.hide())
	tween.tween_callback(func(): $Page/PlayArea/TileGrid.show())
	tween.tween_property($Page/PlayArea, "position", start_pos, 1)
	
	Signals.emit_signal("StartRound")

func _game_over():
	Sounds.lose()
	$GameOverModal.show()
	# TODO: Save any user state
