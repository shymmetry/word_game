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
	"Phone a Friend",
	"Gain 1 extra hint",
	80,
	-1,
	func(): Globals.hints = min(3, Globals.hints+1),
)

var swap = Item.new(
	"Refill Coffee",
	"Fills swaps up to 5",
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

var heal = Item.new(
	"Mmmm Cheese",
	"Heals back 10 health",
	50,
	-1,
	func(): Globals.life = min(50, Globals.life+10),
)

var score_mult_3 = Item.new(
	"Tiny Brained",
	"2x money received from 3 letter words",
	50,
	1,
	func(): {},
)

var score_mult_4 = Item.new(
	"On a Roll",
	"2x money received from 4 letter words",
	100,
	1,
	func(): {},
)

var score_mult_6 = Item.new(
	"Big Brained",
	"1.5x money received from 6+ letter words",
	100,
	1,
	func(): {},
)

var word_heal_3 = Item.new(
	"",
	"Heal 1 every time a word with 3 letters is made",
	25,
	3,
	func(): {},
)

var word_heal_5 = Item.new(
	"Creative Juices",
	"Heal 1 every time a word with 5+ letters is made",
	50,
	3,
	func(): {},
)

var extra_swaps = Item.new(
	"Coffee Machine",
	"Receive 1 swap every time a word with 5+ letters is made",
	125,
	1,
	func(): {},
)
