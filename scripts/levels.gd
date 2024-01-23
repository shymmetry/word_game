extends Node

const level_defaults = preload("res://static/levels/level_defaults.gd")
const endless_config = preload("res://static/levels/endless.gd")
const timed_config = preload("res://static/levels/timed.gd")

# Ordered list of survival rounds
const survival_round_order = [
	"res://static/levels/survival1.gd"
]

func set_endless():
	_set_level_config(endless_config)

func set_timed():
	_set_level_config(timed_config)

func set_current_round(cur_round: int):
	Globals.current_round = cur_round
	
	_set_level_config(load(survival_round_order[cur_round-1]))
	
func _set_level_config(level_data):
	var config_map = level_defaults.new().get_config_map()
	for key in config_map:
		if key in level_data:
			config_map[key] = level_data[key]
	
	Globals.level_data = config_map
