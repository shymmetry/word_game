extends Control

func _ready():
	Signals.connect("WordScored", _update_word_scores)

func _update_word_scores(_score_results: ScoreResults):
	var words = ""
	var dashes = ""
	var scores = ""
	for i in range(min(Globals.matched_words.size() - 1, 4), -1, -1):
		var word_score = Globals.matched_words[Globals.matched_words.size() - i - 1]
		words += "\n%s" % word_score.word
		dashes += "\n-"
		scores += "\n%d" % word_score.score
	
	print(words)
	$Words.text = words
	$Dashes.text = dashes
	$Scores.text = scores
