extends Node
class_name Power

var display_name: String
var energy_cost: int

func _init(_display_name: String, _energy_cost: int):
	display_name = _display_name
	energy_cost = _energy_cost
