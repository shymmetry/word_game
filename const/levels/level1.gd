extends Node
class_name Level1

enum WIN_TYPES {
	SCORE, 
	WORD_SCORE,
	WORD_TOPIC,
	WORD_SIZE,
}

const rows = 6
const cols = 6
const tile_size = 60
const padding = 10

const win_type = WIN_TYPES.SCORE
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

const letter_scores = {
	"E": 1,
	"T": 1,
	"A": 1,
	"O": 1,
	"I": 1,
	"N": 1,
	"S": 1,
	"R": 1,
	"H": 2,
	"D": 2,
	"L": 2,
	"U": 4,
	"C": 4,
	"M": 4,
	"F": 4,
	"Y": 5,
	"W": 5,
	"G": 5,
	"P": 5,
	"B": 5,
	"V": 6,
	"K": 8,
	"X": 10,
	"Q": 10,
	"J": 10,
	"Z": 10,
}
