extends Node

const round_defaults: Resource = preload("res://static/rounds/round_defaults.gd")

# Ordered list of rounds
const round_order: Array[String] = [
	"res://static/rounds/round1.gd",
	"res://static/rounds/round2.gd",
	"res://static/rounds/round3.gd",
	"res://static/rounds/round4.gd",
	"res://static/rounds/round5.gd",
	"res://static/rounds/round6.gd",
	"res://static/rounds/round7.gd",
	"res://static/rounds/round8.gd",
	"res://static/rounds/round9.gd",
	"res://static/rounds/round10.gd",
]

func set_difficulty(difficulty: Difficulty) -> void:
	Globals.difficulty = difficulty

func set_character(character: Character) -> void:
	Globals.character = character

func set_current_round(cur_round: int) -> void:
	Globals.current_round = cur_round
	
	_set_round_config(load(round_order[cur_round-1]))

func total_rounds() -> int:
	return round_order.size()

func _set_round_config(round_data: Resource) -> void:
	var config_map = round_defaults.new().get_config_map()
	for key in config_map:
		if key in round_data:
			config_map[key] = round_data[key]
	
	Globals.round_data = config_map
