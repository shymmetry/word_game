extends Node

const level_defaults = preload("res://scripts/levels/level_defaults.gd")

# Ordered list of levels as their file names
const level_order = [
	"endless",
	"basic",
	"basic2",
	"word_size",
	"word_size2",
	"wildcard_intro",
	"impossible",
]

func set_current_level(level: int):
	Globals.current_level = level
	
	var level_data = load("res://scripts/levels/%s.gd" % level_order[level])
	
	var config_map = level_defaults.new().get_config_map()
	for key in config_map:
		if key in level_data:
			config_map[key] = level_data[key]
	
	Globals.level_data = config_map
