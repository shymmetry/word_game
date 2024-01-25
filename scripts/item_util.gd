extends Node

const _stored_items = preload("res://static/items.gd")

var _items: Dictionary = {}

func _ready():
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

func get_health_for_word(word: String) -> int:
	var heals = Globals.items[_items.word_heal]
	return 0 if !heals else heals

func get_swap_bonus(word: String) -> int:
	var swaps = 0
	if word.length() == 5:
		swaps = Globals.items[_items.medium_word_bonus]
	elif word.length() > 5:
		swaps = Globals.items[_items.big_word_bonus]
	return 0 if !swaps else swaps

func extra_round_time():
	if !_items: return 0
	var time_items = Globals.items[_items.increase_round_time]
	return 10 * (0 if !time_items else time_items)
