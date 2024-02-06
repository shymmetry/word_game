extends Node
class_name Character

var display_name: String
var description: String
var starting_life: int
var starting_energy: int
var starting_items: Array[Item]
var gpt_system: String
var gpt_prompt: String

func _init(_display_name: String, _description: String, _starting_life: int, _starting_energy: int, _starting_items: Array[Item], _gpt_system: String, _gpt_prompt: String):
	display_name = _display_name
	description = _description
	starting_life = _starting_life
	starting_energy = _starting_energy
	starting_items = _starting_items
	gpt_system = _gpt_system
	gpt_prompt = _gpt_prompt
