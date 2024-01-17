extends Node

const level_defaults = preload("res://static/levels/level_defaults.gd")

# Ordered list of levels
const level_order = [
	"res://static/levels/endless.gd",
	"res://static/levels/basic.gd",
	"res://static/levels/basic2.gd",
	"res://static/levels/word_size.gd",
	"res://static/levels/word_size2.gd",
	"res://static/levels/wildcard_intro.gd",
	"res://static/levels/min_size4.gd",
	"res://static/levels/hint_intro.gd",
	"res://static/levels/multiplier_intro.gd",
	"res://static/levels/impossible.gd",
]

func set_current_level(level: int):
	Globals.current_level = level
	
	var level_data = load(level_order[level])
	
	var config_map = level_defaults.new().get_config_map()
	for key in config_map:
		if key in level_data:
			config_map[key] = level_data[key]
	
	Globals.level_data = config_map

# Get the number of levels NOT INCLUDING ENDLESS (0)
func num_levels():
	return level_order.size() - 1
