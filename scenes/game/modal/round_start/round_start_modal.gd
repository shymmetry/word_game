extends CanvasLayer

func reset():
	$Background/VBox/Title/Margin/Label.text = "Poem %d/%d" % [Globals.current_round, Levels.total_rounds()]
	$Background/VBox/Details/Margin/Label.text = _get_round_text()

func _get_round_text() -> String:
	var starting_text = "" if Globals.current_round != 1 else "What a beautiful morning. The sun is shining, 
		you've got a full cup of coffee, and ... oh no ... its Friday and you've slacked 
		off on your writing all week!!! You have 10 poems that you need to submit by the end of the day. 
		You have %d hours to write each poem.\nBetter get to it!\n
		------------------------------------------------------\n\n" % (Globals.difficulty.round_time_seconds / 60)
	
	var word_cnt = "Find %d words of inspiration to write your poem\n\n" % Globals.round_data.word_cnt_goal
	var word_length_min = "For this poem inspirational words must have at least %d letters" % Globals.round_data.min_word_length
	var word_length_max = " and at most %d letters" % Globals.round_data.max_word_length if Globals.round_data.max_word_length else ""
	var win_type = ""
	if Globals.round_data.win_type == E.WIN_TYPE.CONTAINS_SPECIAL:
		win_type = "\n\nWords will only be inspirational if they CONTAIN blue tiles"
	elif Globals.round_data.win_type == E.WIN_TYPE.STARTS_SPECIAL:
		win_type = "\n\nWords will only be inspirational if they START WITH A blue tile"
	
	return starting_text + word_cnt + word_length_min + word_length_max + win_type

func _ready():
	reset()

func _on_button_left_pressed():
	Signals.emit_signal("StartRound")
	Globals.paused = false
	Globals.idle = true
	Globals.round_over = false
	self.hide()
