extends Node

var _letter_picker_freq_total = 0
var _letter_freq = {}

func reset_letter_freq():
	var letter_freq = Globals.round_data.letter_freq
	
	_letter_picker_freq_total = 0
	_letter_freq = _change_letter_freq_difficulty(letter_freq, Globals.round_data.letter_difficulty)
	
	_letter_freq['?'] = ItemUtil.get_wildcard_bonus()
	
	# Populate letter probability selector
	for letter in _letter_freq:
		var freq = _letter_freq[letter]
		_letter_picker_freq_total += freq

func _change_letter_freq_difficulty(letter_freq: Dictionary, difficulty: int) -> Dictionary:
	var freq_total = 0
	for letter in letter_freq:
		freq_total += letter_freq[letter]
	var avg_freq = freq_total / letter_freq.size()
	print(avg_freq)
	
	# The higher the difficulty the more evened out the distribution should be.
	# The lower the difficulty the higher the probability of more common letters
	# and the reduction of probability of less common letters.
	var new_letter_freq = {}
	for letter in letter_freq:
		var freq_diff = letter_freq[letter] - avg_freq
		var freq_delta = int(freq_diff * (difficulty / 5.0))
		new_letter_freq[letter] = max(0, letter_freq[letter] - freq_delta)
	return new_letter_freq

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
