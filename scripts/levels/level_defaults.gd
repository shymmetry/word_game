extends Node

func get_config_map():
	var config_map = {}
	for property_info in get_script().get_script_property_list():
		var property_name: String = property_info.name
		if property_name == "level_defaults.gd": continue
		var property_value = get(property_name)
		config_map[property_name] = property_value
	return config_map

var rows = 6
var cols = 6
var tile_size = 60
var padding = 10

var win_type = E.WIN_TYPE.SCORE
var win_threshold = 1
var win_text = "Get over 1 points"
var win_data = {}
var starting_swaps = 1
var min_word_length = 3

var swap_bonus = {
	4: 0,
	5: 1,
	6: 2,
	7: 2,
	8: 3,
}

var word_length_score_multiplier = {
	4: 1,
	5: 2,
	6: 3,
	7: 5,
	8: 7,
	9: 10,
	10: 15,
}

var letter_scores = {
	"E": 1,
	"T": 1,
	"A": 1,
	"O": 1,
	"I": 1,
	"N": 1,
	"S": 1,
	"R": 1,
	"U": 2,
	"D": 2,
	"L": 2,
	"H": 3,
	"C": 4,
	"M": 4,
	"F": 4,
	"Y": 5,
	"W": 5,
	"G": 5,
	"P": 5,
	"B": 5,
	"V": 6,
	"K": 6,
	"X": 9,
	"Q": 9,
	"J": 9,
	"Z": 9,
}

var letter_freq = {
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
