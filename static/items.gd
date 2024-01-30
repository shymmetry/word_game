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
	"Call Friend",
	"Gain 1 extra hint",
	80,
	-1,
	func(): Globals.hints = min(3, Globals.hints+1),
)

var swap = Item.new(
	"Refill Coffee",
	"Increase swaps up to 5",
	100,
	-1,
	func(): Globals.swaps = 5,
)

var wildcard_bonus = Item.new(
	"Meditate",
	"Increase likelihood of [?] tiles",
	70,
	-1,
	func(): {},
)

var time_bonus = Item.new(
	"Time Extensions",
	"Add 5 more seconds for each poem",
	90,
	-1,
	func(): {},
)

var new_board = Item.new(
	"Cat Nap",
	"Change all the letters on the board",
	50,
	-1,
	func(): Globals.resets = min(3, Globals.resets+1),
)
