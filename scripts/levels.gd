extends Node

const level_defaults = preload("res://scripts/levels/level_defaults.gd")

func set_current_level(level: int):
	Globals.current_level = level
	
	var level_data
	if level == 0:
		level_data = load("res://scripts/levels/endless.gd")
	else:
		level_data = load("res://scripts/levels/level%s.gd" % level)
	
	var config_map = level_defaults.new().get_config_map()
	for key in config_map:
		if key in level_data:
			config_map[key] = level_data[key]
	
	Globals.level_data = config_map
