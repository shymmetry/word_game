extends Node

const level_defaults = preload("res://const/levels/level_defaults.gd")
var default_map = {}

func set_current_level(level: int):
	Globals.current_level = level
	
	var level_data = load("res://const/levels/level%s.gd" % level)
	var config_map = level_defaults.new().get_config_map()
	for key in config_map:
		if key in level_data:
			print(key)
			config_map[key] = level_data[key]
	
	Globals.level_data = config_map
