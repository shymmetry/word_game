extends Node
class_name Letters

var letter_picker_freq_total = 0

func _init():
	# Populate letter probability selector
	for letter in Letters.letter_freq:
		var freq = Letters.letter_freq[letter]
		letter_picker_freq_total += freq

func rand_char():
	var rand_num = randi() % letter_picker_freq_total
	var sum = 0
	var selected_letter = "?"
	for letter in letter_freq:
		sum += letter_freq[letter]
		if sum >= rand_num:
			selected_letter = letter
			break
	
	return selected_letter

const letter_scores = {
	"E": 1,
	"T": 1,
	"A": 1,
	"O": 1,
	"I": 1,
	"N": 1,
	"S": 1,
	"R": 1,
	"H": 2,
	"D": 2,
	"L": 2,
	"U": 4,
	"C": 4,
	"M": 4,
	"F": 4,
	"Y": 5,
	"W": 5,
	"G": 5,
	"P": 5,
	"B": 5,
	"V": 6,
	"K": 8,
	"X": 10,
	"Q": 10,
	"J": 10,
	"Z": 10,
}

const letter_freq = {
	"E": 1202,
	"T": 910,
	"A": 812,
	"O": 768,
	"I": 731,
	"N": 695,
	"S": 628,
	"R": 602,
	"H": 592,
	"D": 432,
	"L": 398,
	"U": 288,
	"C": 271,
	"M": 261,
	"F": 230,
	"Y": 211,
	"W": 209,
	"G": 203,
	"P": 182,
	"B": 149,
	"V": 111,
	"K": 69,
	"X": 17,
	"Q": 11,
	"J": 10,
	"Z": 7
}
