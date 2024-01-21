extends Node

func _ready():
	Signals.connect("WordScored", _increase_difficulty)

func _increase_difficulty(_score_results: ScoreResults):
	var last = Globals.last_processed_score_for_increased_difficulty
	var increases = Globals.score / Globals.points_to_increase_difficulty - last / Globals.points_to_increase_difficulty
	Globals.last_processed_score_for_increased_difficulty = Globals.score
	
	var new_reset_seconds = Globals.reset_seconds
	for _i in range(0, increases):
		if new_reset_seconds > 10:
			new_reset_seconds -= 1
	
	if new_reset_seconds != Globals.reset_seconds:
		Globals.reset_seconds = new_reset_seconds
		Signals.emit_signal("NotifyPlayer", "Refresh reduced to %d seconds" % new_reset_seconds)
