extends Node

func _ready():
	Signals.connect("WordScored", _increase_difficulty)

func _increase_difficulty(_score_results: ScoreResults):
	if Globals.game_mode == E.GAME_TYPE.TIMED:
		var last = Globals.last_processed_score_for_increased_difficulty
		var increases = Globals.score / Globals.round_data.points_to_increase_difficulty - last / Globals.round_data.points_to_increase_difficulty
		Globals.last_processed_score_for_increased_difficulty = Globals.score
		
		var new_round_time = Globals.round_time
		for _i in range(0, increases):
			if new_round_time > 10:
				new_round_time -= 1
		
		if new_round_time != Globals.round_time:
			Globals.round_time = new_round_time
			Signals.emit_signal("NotifyPlayer", "Search time reduced to %d seconds" % new_round_time)
