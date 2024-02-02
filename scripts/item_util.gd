extends Node

const _stored_items = preload("res://static/items.gd")

var _items: Dictionary = {}

func _init():
	var config_map = _stored_items.new().get_all_items()
	for key in config_map:
		_items[key] = config_map[key]

func get_random_items(num: int, game_type: E.GAME_TYPE, duplicates: bool) -> Array[Item]:
	var selected_items: Array[Item] = []
	var items_left = {}
	for item_name in _items:
		var item = _items[item_name]
		if item.game_types.has(game_type) and \
				(!Globals.items.has(item) or item.max_owned == -1 or Globals.items[item] < item.max_owned):
			items_left[item_name] = item
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
		return 50 + Globals.items[_items.wildcard_bonus] * 100
	else: 
		return 50

func get_time_bonus() -> int:
	if Globals.items.has(_items.time_bonus):
		return Globals.items[_items.time_bonus] * 5
	else: 
		return 0

func get_word_mult(word: String) -> int:
	if word.length() >= 6 and Globals.items.has(_items.score_mult_6):
		return Globals.items[_items.score_mult_6] * 1.5
	elif word.length() == 3 and Globals.items.has(_items.score_mult_3):
		return Globals.items[_items.score_mult_3] * 2
	else: 
		return 1

func get_word_heal(word: String) -> int:
	if word.length() >= 5 and Globals.items.has(_items.word_heal):
		return Globals.items[_items.word_heal] * 1
	else:
		return 0

func get_extra_swaps(word: String) -> int:
	if word.length() >= 5 and Globals.items.has(_items.extra_swaps):
		return Globals.items[_items.extra_swaps] * 1
	else:
		return 0
