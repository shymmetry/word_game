extends Node

const starting_swaps = 0
const win_threshold = 200
const goal = "Get over 200 points"
const level_info = "Gold tiles give 2x turd points"
const show_hints = true
const starting_hints = 1
const min_word_length = 4

const tile_type_chance = {
	E.TILE_TYPE.NORMAL: 95,
	E.TILE_TYPE.HARDENED: 0,
	E.TILE_TYPE.MULTIPLIER: 5,
	E.TILE_TYPE.GOAL: 0,
}

const letter_freq = {
	"?": 300,
	"E": 1202,
	"T": 910,
	"A": 812,
	"O": 768,
	"I": 731,
	"N": 695,
	"S": 628,
	"R": 602,
	"H": 592,
	"D": 432,
	"L": 398,
	"U": 288,
	"C": 271,
	"M": 261,
	"F": 230,
	"Y": 211,
	"W": 209,
	"G": 203,
	"P": 182,
	"B": 149,
	"V": 111,
	"K": 69,
	"X": 17,
	"Q": 11,
	"J": 10,
	"Z": 7
}
