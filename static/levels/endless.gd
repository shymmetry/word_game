extends Node

const win_type = E.WIN_TYPE.NONE
const win_threshold = 0
const goal = "Play until you die of exhaustion"
const starting_swaps = 1
const show_hints = true
const starting_hints = 1

const letter_freq = {
	"?": 100,
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
