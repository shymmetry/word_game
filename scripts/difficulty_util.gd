extends Node

func _difficulty_level() -> int:
	return Difficulties.difficulty_progression.find(Globals.difficulty) + 1

func star_freq_percent() -> float:
	if _difficulty_level() >= 2:
		return 1.0
	return 0.8

func use_normal_letter_freq() -> bool:
	if _difficulty_level() >= 3:
		return true
	return false

func item_cost_percent_increase() -> float:
	if _difficulty_level() >= 4:
		return 0.2
	return 0.0

func use_normal_word_cnt() -> bool:
	if _difficulty_level() >= 5:
		return true
	return false

func energy_percent() -> float:
	if _difficulty_level() >= 6:
		return 0.7
	return 1.0

func health_percent() -> float:
	if _difficulty_level() >= 7:
		return 0.5
	return 1.0
