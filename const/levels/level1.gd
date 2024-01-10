extends Node
class_name Level1

const rows = 6
const cols = 6
const tile_size = 60
const padding = 10

const win_type = E.WIN_TYPES.SCORE
const win_threshold = 100
const win_text = "Get over 100 points"
const starting_swaps = 3
const min_word_length = 4

const swap_bonus = {
	4: 1,
	5: 2,
	6: 5,
}

const word_length_score_multiplier = {
	4: 1,
	5: 2,
	6: 5,
}

const letter_scores = Globals.default_letter_scores
const letter_freq = Globals.default_letter_freq
