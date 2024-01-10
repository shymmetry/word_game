extends Node

# Game variables
var tiles = []
var score = 0
var swaps = 1
var board_changed = false
var idle = true
var selected_tile = null
var dragged_tiles = []

# Session variables
var current_level = 0
var level_data = null
func set_current_level(level: int):
	current_level = level
	level_data = load("res://const/levels/level%s.gd" % level)

# Player variables
var high_score = 0
var completed_levels = []

const default_letter_scores = {
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

const default_letter_freq = {
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
