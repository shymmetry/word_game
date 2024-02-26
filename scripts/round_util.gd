extends Node

func word_count_goal() -> int:
	var base_words
	if DifficultyUtil.use_normal_word_cnt():
		base_words = 6
	else:
		base_words = Globals.round_data.word_cnt_goal
	return base_words + ItemUtil.get_extra_words()
