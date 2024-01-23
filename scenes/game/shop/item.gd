extends Node
class_name Item

var item_name: String = ""
var description: String = ""
var cost: int = 0
var effect: Callable = func(): {}

func _init(_item_name: String, _description: String, _cost: int, _effect: Callable):
	item_name = _item_name
	description = _description
	cost = _cost
	effect = _effect
