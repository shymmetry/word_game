extends VBoxContainer

func reset():
	$WordScores/Words.text = ""
	$WordScores/Scores.text = ""
	$Results/Total.text = ""
	$Results/TotalScore.text = ""
	$Results.hide()
	$Line.hide()

func _ready():
	Signals.connect("StartWordScoring", _score_words)

func _score_words() -> void:
	$Timer.set_wait_time(0.2)
	$Timer.start()
	var total_score = 0
	for word_score in Globals.matched_words:
		total_score += word_score.score
		
		$WordScores/Words.text = "%s%s\n" % [$WordScores/Words.text, word_score.word]
		$WordScores/Scores.text = "%s$%d\n" % [$WordScores/Scores.text, word_score.score]
		#Sounds.coin_flip()
		await $Timer.timeout
	
	await $Timer.timeout
	$Results.show()
	$Line.show()
	$Results/Total.text = "PAYMENT"
	$Results/TotalScore.text = "$%d" % total_score
	Sounds.cash_in()
	Globals.score += total_score
	
	$"../../Continue/Button".show()
