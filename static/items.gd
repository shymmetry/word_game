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
	"1 Hint",
	"Get shown the longest word",
	50,
	func(): Globals.hints += 1,
)

var swap = Item.new(
	"2 Swaps",
	"Swap 2 adjacent tiles",
	50,
	func(): Globals.swaps += 2,
)

var heal = Item.new(
	"Heal 20",
	"Increase life by 20",
	50,
	func(): Globals.swaps += 2,
)

var shrink_cols = Item.new(
	"-1 Columns",
	"Remove a column from the board",
	150,
	func(): Globals.cols -= 1,
)
