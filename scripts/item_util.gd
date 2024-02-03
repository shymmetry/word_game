extends Node

const _stored_items = preload("res://static/items.gd")

var _items: Dictionary = {}

func _init():
	var config_map = _stored_items.new().get_all_items()
	for key in config_map:
		_items[key] = config_map[key]

func get_random_items(num: int, duplicates: bool) -> Array[Item]:
	var selected_items: Array[Item] = []
	var items_left = {}
	for item_name in _items:
		var item = _items[item_name]
		if !Globals.items.has(item) or item.max_owned == -1 or Globals.items[item] < item.max_owned:
			items_left[item_name] = item
	for i in range(0, num):
		var rand = randi() % items_left.keys().size()
		var rand_key = items_left.keys()[rand]
		selected_items.append(items_left.get(rand_key))
		if !duplicates:
			items_left.erase(rand_key)
	return selected_items

func get_wildcard_bonus() -> int:
	if Globals.items.has(_items.wildcard_bonus):
		return 50 + Globals.items[_items.wildcard_bonus] * 100
	else: 
		return 50

func get_word_mult(word: String) -> int:
	if word.length() >= 6 and Globals.items.has(_items.score_mult_6):
		return Globals.items[_items.score_mult_6] * 1.5
	elif word.length() == 4 and Globals.items.has(_items.score_mult_4):
		return Globals.items[_items.score_mult_4] * 2
	elif word.length() == 3 and Globals.items.has(_items.score_mult_3):
		return Globals.items[_items.score_mult_3] * 2
	else:
		return 1

func get_word_heal(word: String) -> int:
	if word.length() >= 5 and Globals.items.has(_items.word_heal_5):
		return Globals.items[_items.word_heal] * 1
	elif word.length() == 3 and Globals.items.has(_items.word_heal_3):
		return Globals.items[_items.word_heal] * 1
	else:
		return 0

func get_word_energy(word: String) -> int:
	if word.length() >= 5 and Globals.items.has(_items.extra_swaps_5):
		return Globals.items[_items.extra_swaps_5] * 1
	elif word.length() == 3 and Globals.items.has(_items.extra_swaps_3):
		return Globals.items[_items.extra_swaps_3] * 1
	else:
		return 0
