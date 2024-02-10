extends Node

var _items: Dictionary = {}

func _ready():
	var config_map = Items.get_all_items()
	for key in config_map:
		_items[key] = config_map[key]

func get_all_items() -> Array[Item]:
	var items: Array[Item] = []
	var all_items = Items.get_all_items()
	for item in all_items:
		items.append(all_items[item])
	return items

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
	if Globals.items.has(Items.wildcard_bonus):
		return 50 + Globals.items[Items.wildcard_bonus] * 200
	else: 
		return 50

func get_word_mult(word: String) -> int:
	var mult = 1
	if word.length() >= 6 and Globals.items.has(Items.score_mult_6):
		mult *= Globals.items[Items.score_mult_6] * 1.5
	elif word.length() == 4 and Globals.items.has(Items.score_mult_4):
		mult *= Globals.items[Items.score_mult_4] * 2
	elif word.length() == 3 and Globals.items.has(Items.score_mult_3):
		mult *= Globals.items[Items.score_mult_3] * 2
	
	if Globals.items.has(Items.poop_jokes) and Dict.is_poop_word(word):
		mult *= Globals.items[Items.poop_jokes] * 2
	
	return mult

func get_word_heal(word: String) -> int:
	if word.length() >= 5 and Globals.items.has(Items.word_heal_5):
		return Globals.items[Items.word_heal_5] * 1
	elif word.length() == 3 and Globals.items.has(Items.word_heal_3):
		return Globals.items[Items.word_heal_3] * 1
	else:
		return 0

func get_word_energy(word: String) -> int:
	if word.length() >= 5 and Globals.items.has(Items.extra_swaps_5):
		return Globals.items[Items.extra_swaps_5] * 1
	elif word.length() == 3 and Globals.items.has(Items.extra_swaps_3):
		return Globals.items[Items.extra_swaps_3] * 1
	else:
		return 0

func get_energy_cash(energy: int) -> int:
	if Globals.items.has(Items.second_job):
		return Globals.items[Items.second_job] * 5 * energy
	return 0

func get_item_price(base_price: int) -> int:
	var percent_increase = DifficultyUtil.item_cost_percent_increase()
	var num_item = Globals.items[Items.coupon_book] if Globals.items.has(Items.coupon_book) else 0
	
	return floor(base_price * (1.0 - num_item * 0.10 + percent_increase))
