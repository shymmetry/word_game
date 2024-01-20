extends Node

var _letter_picker_freq_total = 0
var _letter_freq = {}

func set_letter_freq(letter_freq):
	_letter_picker_freq_total = 0
	_letter_freq = letter_freq
	
	# Populate letter probability selector
	for letter in letter_freq:
		var freq = letter_freq[letter]
		_letter_picker_freq_total += freq

# Returns the probability that a letter will get selected in the current
# game as a map from letter to probability.
func get_letter_probabilities():
	var probs = {}
	for letter in _letter_freq:
		var freq = _letter_freq[letter]
		var prob = 1.0 * freq / _letter_picker_freq_total
		probs[letter] = prob
	return probs

func rand_char():
	var rand_num = randi() % _letter_picker_freq_total + 1
	var sum = 0
	var selected_letter = "?"
	for letter in _letter_freq:
		sum += _letter_freq[letter]
		if sum >= rand_num:
			selected_letter = letter
			break
	
	return selected_letter
