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
	75,
	-1,
	func(): Globals.hints += 1,
)

var swap = Item.new(
	"Refill Coffee",
	"Increase swaps back to 3",
	100,
	-1,
	func(): Globals.swaps = 3,
)

var wildcard_bonus = Item.new(
	"Meditate",
	"Increase likelihood of [?] tiles",
	100,
	-1,
	Callable(),
)

var time_bonus = Item.new(
	"Time Extensions",
	"Add 3 more seconds for each poem",
	125,
	-1,
	Callable(),
)
