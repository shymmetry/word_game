extends Node
class_name LetterUtil

var letter_picker_freq_total = 0

func _init():
	# Populate letter probability selector
	for letter in Globals.level_data.letter_freq:
		var freq = Globals.level_data.letter_freq[letter]
		letter_picker_freq_total += freq

func rand_char():
	var rand_num = randi() % letter_picker_freq_total
	var sum = 0
	var selected_letter = "?"
	for letter in Globals.level_data.letter_freq:
		sum += Globals.level_data.letter_freq[letter]
		if sum >= rand_num:
			selected_letter = letter
			break
	
	return selected_letter
