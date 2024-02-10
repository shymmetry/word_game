extends Node

func difficulty_number(difficulty: Difficulty) -> int:
	return Difficulties.difficulty_progression.find(difficulty)

func star_freq_percent() -> float:
	if difficulty_number(Globals.difficulty) >= 1:
		return 1.0
	return 0.8

func use_normal_letter_freq() -> bool:
	if difficulty_number(Globals.difficulty) >= 2:
		return true
	return false

func item_cost_percent_increase() -> float:
	if difficulty_number(Globals.difficulty) >= 3:
		return 0.2
	return 0.0

func use_normal_word_cnt() -> bool:
	if difficulty_number(Globals.difficulty) >= 4:
		return true
	return false

func energy_percent() -> float:
	if difficulty_number(Globals.difficulty) >= 5:
		return 0.7
	return 1.0

func health_percent() -> float:
	if difficulty_number(Globals.difficulty) >= 6:
		return 0.5
	return 1.0
