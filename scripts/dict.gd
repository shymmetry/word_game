extends Node

const poop_words = [
	"crap", "craps", "crapped", "dookie", "dung", "dungs", "excrement", "fecal", "feces", "excreta",
	"scat", "scats", "dropping", "soil", "dirt", "ordure", "poo", "pooed", "pooping", "poop", "poops",
	"poos", "stool", "manure", "waste", "shit", "shits", "turd", "turds", "shat", "fart", "shart",
	"shitted", "shitting", "loo", "potty", "loos", "shitter", "pooper", "pooped"
]

var words = {}

func _init():
	# Populate dictionary
	load_words(words, "res://static/dictionary.txt")

func load_words(dict: Dictionary, file_name: String):
	var file = FileAccess.open(file_name, FileAccess.READ)
	while not file.eof_reached():
		var content = file.get_line()
		dict[content] = null
	file.close()

func is_word(word: String):
	return words.has(word.to_upper())

func is_poop_word(word: String):
	poop_words.has(word.to_lower())
