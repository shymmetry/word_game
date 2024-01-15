extends Node

const level_defaults = preload("res://scripts/levels/level_defaults.gd")

# Ordered list of levels
const level_order = [
	"res://scripts/levels/endless.gd",
	"res://scripts/levels/basic.gd",
	"res://scripts/levels/basic2.gd",
	"res://scripts/levels/word_size.gd",
	"res://scripts/levels/word_size2.gd",
	"res://scripts/levels/wildcard_intro.gd",
	"res://scripts/levels/min_size4.gd",
	"res://scripts/levels/multiplier_intro.gd",
	"res://scripts/levels/impossible.gd",
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
