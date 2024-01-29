extends Node

const _stored_items = preload("res://static/items.gd")

var _items: Dictionary = {}

func _init():
	var config_map = _stored_items.new().get_all_items()
	for key in config_map:
		_items[key] = config_map[key]

func get_random_items(num: int, duplicates: bool) -> Array[Item]:
	var selected_items: Array[Item] = []
	var items_left = _items.duplicate()
	for i in range(0, num):
		var rand = randi() % items_left.keys().size()
		var rand_key = items_left.keys()[rand]
		selected_items.append(items_left.get(rand_key))
		if !duplicates:
			items_left.erase(rand_key)
	return selected_items

func get_swap_bonus(word: String) -> int:
	if word.length() == 5:
		return Globals.items[_items.medium_word_bonus] if Globals.items.has(_items.medium_word_bonus) else 0
	elif word.length() > 5:
		return Globals.items[_items.big_word_bonus] if Globals.items.has(_items.big_word_bonus) else 0
	else:
		return 0

func get_wildcard_bonus() -> int:
	if Globals.items.has(_items.wildcard_bonus):
		return Globals.items[_items.wildcard_bonus] * 100
	else: 
		return 0

func get_time_bonus() -> int:
	if Globals.items.has(_items.time_bonus):
		return Globals.items[_items.time_bonus] * 5
	else: 
		return 0
