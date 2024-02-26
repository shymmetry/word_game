extends Node
class_name Power

var display_name: String
var base_energy_cost: int

func _init(_display_name: String, _base_energy_cost: int):
	display_name = _display_name
	base_energy_cost = _base_energy_cost
