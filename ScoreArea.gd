extends Node2D

const Letters = preload("res://const/letters.gd")

var score = 0
var swaps = 5
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
func _ready():
	$ScoreNumber.text = str(score)
	$SwapsNumber.text = str(swaps)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func score_word(word: String):
	# Update score
	var score_up = 0
	for char in word:
		score_up += Letters.letter_scores.get(char)
	score_up = score_up * word_length_score_multiplier.get(word.length())
	score += score_up
	$ScoreNumber.text = str(score)
	
	# Update swap count
	var bonus = swap_bonus.get(word.length())
	assert(bonus)
	swaps += bonus
	$SwapsNumber.text = str(swaps)
	
	# Update words display
	var new_matched_words = [word]
	new_matched_words.append_array(matched_words.slice(0, 5))
	matched_words = new_matched_words
	var display_words = ""
	for matched_word in matched_words:
		display_words = matched_word + "\n" + display_words
	$Words.text = display_words

func count_swap():
	swaps -= 1
	$SwapsNumber.text = str(swaps)

func can_swap():
	return swaps > 0
