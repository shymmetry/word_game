extends Node
class_name Difficulty

var display_name: String
var description: String
var round_time_seconds: int

func _init(_display_name: String, _description: String, _round_time_seconds: int):
	display_name = _display_name
	description = _description
	round_time_seconds = _round_time_seconds
