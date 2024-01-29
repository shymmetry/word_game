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
	print("scoring words")
	$Timer.set_wait_time(0.4)
	$Timer.start()
	var total_score = 0
	for word_score in Globals.matched_words:
		total_score += word_score.score
		
		$WordList/Words.text = $WordList/Words.text + word_score.word + "\n"
		await $Timer.timeout
		$ScoreList/Scores.text = $ScoreList/Scores.text + str(word_score.score) + "\n"
		await $Timer.timeout
	
	$WordList/Total.show()
	await $Timer.timeout
	$WordList/Total.text = "TOTAL"
	await $Timer.timeout
	$ScoreList/TotalScore.show()
	await $Timer.timeout
	$ScoreList/TotalScore.text = str(total_score)
	Globals.score += total_score
