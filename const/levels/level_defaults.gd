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

var win_type = E.WIN_TYPES.SCORE
var win_threshold = 1
var win_text = "Get over 1 points"
var starting_swaps = 3
var min_word_length = 4

var swap_bonus = {
	4: 1,
	5: 2,
	6: 5,
}

var word_length_score_multiplier = {
	4: 1,
	5: 2,
	6: 5,
}

var letter_scores = Globals.default_letter_scores
var letter_freq = Globals.default_letter_freq
