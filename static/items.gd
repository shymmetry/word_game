extends Node

func get_all_items():
	var config_map = {}
	for property_info in get_script().get_script_property_list():
		var property_name: String = property_info.name
		if property_name == "items.gd": continue
		var property_value = get(property_name)
		config_map[property_name] = property_value
	return config_map

var wildcard_bonus = Item.new(
	"Dumb Luck",
	"Increase likelihood of [?] tiles",
	50,
	5,
	Callable(),
)

var heal = Item.new(
	"Mmmm Cheese",
	"Heal 10",
	50,
	-1,
	func(): Globals.life = Globals.life+10,
)

var score_mult_3 = Item.new(
	"Tiny Brained",
	"2x pay received from 3 letter words",
	40,
	1,
	Callable(),
)

var score_mult_4 = Item.new(
	"Mass Appeal",
	"2x pay received from 4 letter words",
	80,
	1,
	Callable(),
)

var score_mult_6 = Item.new(
	"Big Brained",
	"1.5x pay received from 6+ letter words",
	80,
	1,
	Callable(),
)

var word_heal_3 = Item.new(
	"Feed the Weak",
	"Heal 1 every time a word with 3 letters is found",
	25,
	3,
	Callable(),
)

var word_heal_5 = Item.new(
	"Creative Juices",
	"Heal 1 every time a word with 5+ letters is found",
	50,
	3,
	Callable(),
)

var extra_swaps_3 = Item.new(
	"Procrastination",
	"Recover 1 energy every time a word with 3 letters is found",
	40,
	1,
	Callable(),
)

var extra_swaps_5 = Item.new(
	"Creative Energy",
	"Recover 1 energy every time a word with 5+ letters is found",
	70,
	1,
	Callable(),
)

var max_energy = Item.new(
	"Meditate",
	"Increase max energy by 2",
	120,
	3,
	func(): Globals.max_energy += 2,
)

var poop_jokes = Item.new(
	"Poop Jokes",
	"2x pay on all turd related words",
	45,
	0,
	Callable(),
)

var second_job = Item.new(
	"Second Job",
	"Earn $5 for each unspent energy",
	50,
	2,
	Callable(),
)

var coupon_book = Item.new(
	"Coupon Book",
	"Everything at the shop costs 10% less",
	50,
	3,
	Callable(),
)

var swap_cost_reduc = Item.new(
	"Master Swapper",
	"Swap power costs 1 less energy",
	150,
	1,
	Callable(),
)

var hint_cost_reduc = Item.new(
	"Master Hinter",
	"Hint power cost 1 less energy",
	125,
	1,
	Callable(),
)

var wild_cost_reduc = Item.new(
	"Master Wildcard",
	"Wild power cost 1 less energy",
	110,
	1,
	Callable(),
)

var extra_word = Item.new(
	"Longer Literature",
	"All rounds have 1 more word to complete",
	160,
	1,
	Callable(),
)

var vowel_score = Item.new(
	"Vocalic Visionary",
	"AEIOU score 1 more",
	50,
	2,
	Callable(),
)

var wild_score = Item.new(
	"Random Acts of Kindness",
	"Wildcard tiles score 2 more",
	40,
	3,
	Callable(),
)

var all_tile_score = Item.new(
	"Pay Raise",
	"All letters score 1 more",
	140,
	2,
	Callable(),
)
