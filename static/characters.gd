extends Node

var poet = Character.new(
	"Poet",
	"Starts with Creative Energy\n80 Health and 7 Energy",
	80,
	8,
	[Items.extra_swaps_5],
	"You are a poetic assistant",
	"Write a 4 line poem under 40 words that contains all of the words: %s",
)

var jester = Character.new(
	"Jester",
	"Starts with 2 Poop Jokes\n70 Health and 10 Energy",
	70,
	10,
	[Items.poop_jokes, Items.poop_jokes],
	"You are a joke creating assistant",
	"Write a joke under 40 words that contains all of the words: %s",
)

var samurai = Character.new(
	"Samurai",
	"Starts with 1 Meditate\n60 Health and 10 Energy",
	60,
	10,
	[Items.max_energy],
	"You are a haiku creating assistant",
	"Write a haiku that contains some of the words: %s",
)

var leprechaun = Character.new(
	"Leprechaun",
	"Starts with 3 Dumb Luck\n77 Health and 7 Energy",
	77,
	7,
	[Items.wildcard_bonus, Items.wildcard_bonus, Items.wildcard_bonus],
	"You are a limerick creating assistant",
	"Write a limerick that contains all of the words: %s",
)

var character_progression = [poet, jester, samurai, leprechaun]
