extends HBoxContainer

func reset():
	$WordList/Words.text = ""
	$WordList/Total.text = ""
	$WordList/Total.hide()
	$ScoreList/Scores.text = ""
	$ScoreList/TotalScore.text = ""
	$ScoreList/TotalScore.hide()

func _ready():
	Signals.connect("StartWordScoring", _score_words)

func _score_words() -> void:
	$Timer.set_wait_time(0.4)
	$Timer.start()
	var total_score = 0
	for word_score in Globals.matched_words:
		total_score += word_score.score
		
		$WordList/Words.text = "%s%s\n" % [$WordList/Words.text, word_score.word]
		await $Timer.timeout
		$ScoreList/Scores.text = "%s$%d\n" % [$ScoreList/Scores.text, word_score.score]
		#Sounds.coin_flip()
		await $Timer.timeout
	
	$WordList/Total.show()
	$ScoreList/TotalScore.show()
	await $Timer.timeout
	$WordList/Total.text = "PAYMENT"
	$ScoreList/TotalScore.text = "$%d" % total_score
	Sounds.cash_in()
	Globals.score += total_score
	
	$"../../Continue/Button".show()
