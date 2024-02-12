extends Control

func _init():
	# Handle if loaded outside of menu
	# TODO: Only actually used for testing, figure out how to handle better
	if Globals.current_round == 0:
		Store.load_game()
		Levels.set_character(Characters.jester)
		Levels.set_difficulty(Difficulties.dif1)
		Levels.set_current_round(1)
		for item in ItemUtil.get_all_items():
			Globals.items[item] = 3
	else:
		Globals.items = {}
	
	# Init game state
	Globals.paused = true
	Globals.idle = false
	Globals.score = 0
	Globals.life = floor(Globals.character.starting_life * DifficultyUtil.health_percent())
	Globals.max_energy = floor(Globals.character.starting_energy * DifficultyUtil.energy_percent())
	Globals.shop_refresh_cost = Globals.round_data.shop_refresh_cost
	for item in Globals.character.starting_items:
		if Globals.items.has(item): Globals.items[item] = Globals.items[item] + 1
		else: Globals.items[item] = 1
	
	_init_round()

func _init_round():
	Globals.energy = Globals.max_energy
	Globals.matched_words = []
	LetterUtil.reset_letter_freq()

func _ready():
	Signals.connect("ResetGame", _reset)
	Signals.connect("GameOver", _game_over)
	Signals.connect("NextRound", _next_round)
	Signals.connect("ShowShop", _show_shop)
	Signals.connect("BoardChanged", _on_board_changed)

func _on_board_changed():
	# Every time the board state changes and a hint was present, remove the
	# hint as it is considered outdated.
	if Globals.hint_tiles:
		Globals.hint_tiles = []
	
	# Check if the round has been won
	if Globals.matched_words.size() >= RoundUtil.word_count_goal():
		_round_over()

func _reset():
	Levels.set_current_round(1)
	get_tree().reload_current_scene()

func _round_over():
	Globals.paused = true
	Globals.idle = false
	Globals.round_over = true
	
	# Handle damage taking
	var life_tracker = $Page/HUD/HBoxContainer/Trackers/LifeTracker
	var tracker_pos = life_tracker.global_position + life_tracker.size / 2
	await $DamageHandler.take_damage(tracker_pos)
	
	if Globals.life <= 0: 
		_game_over()
		return
	
	# Reset poem results and then trigger round over to start processing
	$Page/PlayArea/PoemResults.reset()
	Signals.emit_signal("RoundOver")
	
	var start_pos = $Page/PlayArea.position
	var tween = create_tween()
	tween.tween_property($Page/PlayArea, "position", start_pos + Vector2(0, 500), 1)
	tween.tween_callback(func(): $Page/PlayArea/TileGrid.hide())
	tween.tween_callback(func(): $Page/PlayArea/Shop.hide())
	tween.tween_callback(func(): $Page/PlayArea/PoemResults.show())
	tween.tween_property($Page/PlayArea, "position", start_pos, 1)

func _show_shop():
	if Globals.current_round == Levels.total_rounds():
		_has_won()
		return
	
	var start_pos = $Page/PlayArea.position
	var tween = create_tween()
	tween.tween_property($Page/PlayArea, "position", start_pos + Vector2(0, 500), 1)
	tween.tween_callback(func(): $Page/PlayArea/TileGrid.hide())
	tween.tween_callback(func(): $Page/PlayArea/PoemResults.hide())
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
	
	$RoundStartModal.reset()
	$RoundStartModal.show()
	
	# Swap the Play Area content
	var start_pos = $Page/PlayArea.position
	var tween = create_tween()
	tween.tween_property($Page/PlayArea, "position", start_pos + Vector2(0, 500), 1)
	tween.tween_callback(func(): $Page/PlayArea/Shop.hide())
	tween.tween_callback(func(): $Page/PlayArea/PoemResults.hide())
	tween.tween_callback(func(): $Page/PlayArea/TileGrid.show())
	tween.tween_property($Page/PlayArea, "position", start_pos, 1)

func _has_won():
	if UserData.difficulty_unlocks.has(Globals.character.display_name):
		var difficulty_unlock = UserData.difficulty_unlocks[Globals.character.display_name]
		if DifficultyUtil.difficulty_number(Globals.difficulty) == difficulty_unlock:
			UserData.difficulty_unlocks[Globals.character.display_name] = difficulty_unlock + 1
			$WinModal.set_unlock(Difficulties.difficulty_progression[difficulty_unlock + 1])
		else:
			$WinModal.clear_unlock()
	else:
		UserData.difficulty_unlocks[Globals.character.display_name] = 1
		$WinModal.set_unlock(Difficulties.difficulty_progression[1])
	Store.save_game()
	$WinModal.show()

func _game_over():
	Sounds.lose()
	$GameOverModal.show()
	# TODO: Save any user state
