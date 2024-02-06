extends Node
class_name Difficulty

var display_name: String
var description: String
var percent_life: int
var percent_energy: int

func _init(_display_name: String, _description: String, _percent_life: int, _percent_energy: int):
	display_name = _display_name
	description = _description
	percent_life = _percent_life
	percent_energy = _percent_energy
