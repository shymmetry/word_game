extends Node
class_name Item

var item_name: String
var description: String
var cost: int
var max_owned: int
var effect: Callable
var game_types: Array[E.GAME_TYPE]

func _init(_item_name: String, _description: String, _cost: int, _max_owned: int, _effect: Callable, _game_types: Array[E.GAME_TYPE]):
	item_name = _item_name
	description = _description
	cost = _cost
	max_owned = _max_owned
	effect = _effect
	game_types = _game_types
