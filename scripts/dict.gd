extends Node
class_name EnglishDict

var words = {}

func _init():
	# Populate dictionary
	load_words(words, "res://static/usa_words/words4.txt")
	load_words(words, "res://static/usa_words/words5.txt")
	load_words(words, "res://static/usa_words/words6.txt")

func load_words(dict: Dictionary, file_name: String):
	var file = FileAccess.open(file_name, FileAccess.READ)
	while not file.eof_reached():
		var content = file.get_line()
		dict[content] = null
