extends Node

const level_defaults = preload("res://static/levels/level_defaults.gd")
const endless_config = preload("res://static/levels/endless.gd")

# Ordered list of levels
const level_order = [
]

func set_endless():
	set_level_config(endless_config)

func set_current_level(level: int):
	Globals.current_level = level
	
	set_level_config(load(level_order[level]))
	
func set_level_config(level_data):
	var config_map = level_defaults.new().get_config_map()
	for key in config_map:
		if key in level_data:
			config_map[key] = level_data[key]
	
	Globals.level_data = config_map
