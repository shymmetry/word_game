extends CanvasLayer

func reset():
	$Background/VBox/Title/Margin/Label.text = "Round %d/%d" % [Globals.current_round, Levels.total_rounds()]
	$Background/VBox/Details/Margin/Label.text = _get_round_text()

func _get_round_text() -> String:
	var word_cnt = "Find %d words of inspiration\n\n" % RoundUtil.word_count_goal()
	var word_length_min = "For this poem inspirational words must have at least %d letters" % Globals.round_data.min_word_length
	var word_length_max = " and at most %d letters" % Globals.round_data.max_word_length if Globals.round_data.max_word_length else ""
	
	var win_type = ""
	if Globals.round_data.win_type == E.WIN_TYPE.CONTAINS_SPECIAL:
		win_type = "\n\nWords will only be inspirational if they CONTAIN blue tiles"
	elif Globals.round_data.win_type == E.WIN_TYPE.STARTS_SPECIAL:
		win_type = "\n\nWords will only be inspirational if they START WITH A blue tile"
	
	return word_cnt + word_length_min + word_length_max + win_type

func _ready():
	reset()

func _on_button_left_pressed():
	Globals.paused = false
	Globals.idle = true
	Globals.round_over = false
	# Important to call this after setting the above as some signal receivers might update them
	Signals.emit_signal("StartRound")
	self.hide()
