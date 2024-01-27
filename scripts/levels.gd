extends Node

const level_defaults: Resource = preload("res://static/levels/level_defaults.gd")
const endless_config: Resource = preload("res://static/levels/endless.gd")
const timed_config: Resource = preload("res://static/levels/timed.gd")
const survival_defaults: Resource = preload("res://static/levels/survival_defaults.gd")

# Ordered list of survival rounds
const survival_round_order: Array[String] = [
	"res://static/levels/survival1.gd",
	"res://static/levels/survival2.gd",
	"res://static/levels/survival3.gd",
	"res://static/levels/survival4.gd",
	"res://static/levels/survival5.gd",
	"res://static/levels/survival6.gd",
	"res://static/levels/survival7.gd",
	"res://static/levels/survival8.gd",
	"res://static/levels/survival9.gd",
	"res://static/levels/survival10.gd",
]

func set_current_round(cur_round: int) -> void:
	Globals.current_round = cur_round
	
	_set_level_config(load(survival_round_order[cur_round-1]), true)

func total_rounds() -> int:
	return survival_round_order.size()

func _set_level_config(round_data: Resource, survival: bool) -> void:
	var config_map = level_defaults.new().get_config_map()
	for key in config_map:
		if survival and key in survival_defaults:
			config_map[key] = survival_defaults[key]
		if key in round_data:
			config_map[key] = round_data[key]
	
	Globals.round_data = config_map
