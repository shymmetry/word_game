extends Node

func get_all_items():
	var config_map = {}
	for property_info in get_script().get_script_property_list():
		var property_name: String = property_info.name
		if property_name == "items.gd": continue
		var property_value = get(property_name)
		config_map[property_name] = property_value
	return config_map

var hint = Item.new(
	"Send Help",
	"Gain 1 extra hint",
	50,
	-1,
	func(): Globals.hints += 1,
)

var swap = Item.new(
	"Swap Master",
	"Gain 2 extra swaps",
	50,
	-1,
	func(): Globals.swaps += 2,
)

var medium_word_bonus = Item.new(
	"Medium Word Bonus",
	"Gain 1 swap for 5 letter words",
	200,
	3,
	Callable(),
)

var big_word_bonus = Item.new(
	"Big Word Bonus",
	"Gain 1 swap for 6+ letter words",
	50,
	3,
	Callable(),
)
