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
	[E.GAME_TYPE.TIMED],
)

var swap = Item.new(
	"Refill Coffee",
	"Fills swaps up to 5",
	100,
	-1,
	func(): Globals.swaps = 5,
	[E.GAME_TYPE.ATTACK, E.GAME_TYPE.TIMED],
)

var wildcard_bonus = Item.new(
	"Meditate",
	"Increase likelihood of [?] tiles",
	70,
	-1,
	func(): {},
	[E.GAME_TYPE.ATTACK, E.GAME_TYPE.TIMED],
)

var time_bonus = Item.new(
	"Time Extensions",
	"Add 5 more seconds for each poem",
	90,
	-1,
	func(): {},
	[E.GAME_TYPE.TIMED],
)

var new_board = Item.new(
	"Cat Nap",
	"Change all the letters on the board",
	50,
	-1,
	func(): Globals.resets = min(3, Globals.resets+1),
	[E.GAME_TYPE.TIMED],
)

var heal = Item.new(
	"Mmmm Cheese",
	"Heals back 10 health",
	50,
	-1,
	func(): Globals.life = min(50, Globals.life+10),
	[E.GAME_TYPE.ATTACK],
)

var score_mult_3 = Item.new(
	"Tiny Brained",
	"2x money received from 3 letter words",
	50,
	1,
	func(): {},
	[E.GAME_TYPE.ATTACK],
)

var score_mult_6 = Item.new(
	"Big Brained",
	"1.5x money received from 6+ letter words",
	100,
	1,
	func(): {},
	[E.GAME_TYPE.ATTACK],
)

var word_heal = Item.new(
	"Creative Juices",
	"Heal 1 every time a word with 5+ letters is made",
	50,
	3,
	func(): {},
	[E.GAME_TYPE.ATTACK],
)

var extra_swaps = Item.new(
	"Coffee Machine",
	"Receive 1 swap every time a word with 5+ letters is made",
	125,
	1,
	func(): {},
	[E.GAME_TYPE.ATTACK],
)
