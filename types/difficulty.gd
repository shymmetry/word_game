extends Node
class_name Difficulty

var display_name: String
var description: String
var starting_life: int

func _init(_display_name: String, _description: String, _starting_life: int):
	display_name = _display_name
	description = _description
	starting_life = _starting_life
