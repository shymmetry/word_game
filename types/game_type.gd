extends Node
class_name GameType

var display_name: String
var description: String
var game_type: E.GAME_TYPE

func _init(_display_name: String, _description: String, _game_type: E.GAME_TYPE):
	display_name = _display_name
	description = _description
	game_type = _game_type
