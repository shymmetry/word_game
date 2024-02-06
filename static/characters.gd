extends Node

var poet = Character.new(
	"Poet",
	"Starts with Creative Juices\n80 Health and 7 Energy",
	80,
	7,
	[Items.word_heal_5],
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

var character_progression = [poet, jester]
