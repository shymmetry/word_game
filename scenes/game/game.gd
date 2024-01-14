extends Control

func _init():
	if !Globals.level_data:
		Levels.set_current_level(1)
	
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
			$WinScreenCL.show()
			Store.save_game()
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
	if Globals.level_data.win_type == E.WIN_TYPE.NONE:
		var endless_data = UserData.completed_levels.get("0")
		if !endless_data:
			UserData.completed_levels["0"] = {"high_score": Globals.score}
			Store.save_game()
		elif Globals.score > endless_data.high_score:
			UserData.completed_levels["0"].high_score = Globals.score
			Store.save_game()
