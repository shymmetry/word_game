extends CanvasLayer

func reset():
	$Background/VBox/Title/Margin/Label.text = "Poem %d/%d" % [Globals.current_round, Levels.total_rounds()]
	$Background/VBox/Details/Margin/Label.text = _get_round_text()

func _get_round_text() -> String:
	var word_cnt = "Find %d words of inspiration" % Globals.round_data.word_cnt_goal
	var word_length_min = "For this poem inspirational words must have at least %d letters" % Globals.round_data.min_word_length
	var word_length_max = " and at most %d letters" % Globals.round_data.max_word_length if Globals.round_data.max_word_length else ""
	
	return "%s\n\n%s%s" % [word_cnt, word_length_min, word_length_max]

func _ready():
	reset()

func _on_button_left_pressed():
	Signals.emit_signal("StartRound")
	Globals.paused = false
	Globals.idle = true
	self.hide()
