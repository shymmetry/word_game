extends Node

func word_count_goal() -> int:
	if DifficultyUtil.use_normal_word_cnt():
		return 6
	else:
		return Globals.round_data.word_cnt_goal
