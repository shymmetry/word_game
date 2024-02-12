extends Node
class_name Item

var item_name: String
var description: String
var base_cost: int
var max_owned: int
var effect: Callable

func _init(_item_name: String, _description: String, _base_cost: int, _max_owned: int, _effect: Callable):
	item_name = _item_name
	description = _description
	base_cost = _base_cost
	max_owned = _max_owned
	effect = _effect
