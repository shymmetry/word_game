extends Node2D

const Letters = preload("res://const/letters.gd")

var matched_words = []
var swap_bonus = {
	4: 1,
	5: 2,
	6: 5,
}
var word_length_score_multiplier = {
	4: 1,
	5: 2,
	6: 5,
}

# Called when the node enters the scene tree for the first time.
func _process(delta):
	$ScoreNumber.text = str(Globals.score)
	$SwapsNumber.text = str(Globals.swaps)
	$Goal.text = str(Globals.level_data.win_text)
	$ProgressBar.max_value = Globals.level_data.win_threshold
	$ProgressBar.value = Globals.score

func score_word(word: String):
	# Update score
	var score_up = 0
	for char in word:
		score_up += Letters.letter_scores.get(char)
	score_up = score_up * word_length_score_multiplier.get(word.length())
	Globals.score += score_up
	
	# Update swap count
	var bonus = swap_bonus.get(word.length())
	assert(bonus)
	Globals.swaps += bonus
	
	# Update words display
	var new_matched_words = [word]
	new_matched_words.append_array(matched_words.slice(0, 4))
	matched_words = new_matched_words
	var display_words = ""
	for matched_word in matched_words:
		display_words = matched_word + "\n" + display_words
	$Words.text = display_words

func count_swap():
	Globals.swaps -= 1
	$SwapsNumber.text = str(Globals.swaps)
