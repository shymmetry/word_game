extends Node
class_name EnglishDict

var words = {}

func _init():
	# Populate dictionary
	load_words(words, "res://static/collins_scrabble_words_2019.txt")

func load_words(dict: Dictionary, file_name: String):
	var file = FileAccess.open(file_name, FileAccess.READ)
	while not file.eof_reached():
		var content = file.get_line()
		dict[content] = null

func is_word(word: String):
	return words.has(word.to_upper())
