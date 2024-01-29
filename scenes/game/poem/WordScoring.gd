extends HBoxContainer

func reset():
	$Words.text = ""
	$Scores.text = ""

func _ready():
	Signals.connect("StartWordScoring", _score_words)

func _score_words() -> void:
	print("scoring words")
	$Timer.set_wait_time(0.5)
	$Timer.start()
	for word_score in Globals.matched_words:
		$Words.text = $Words.text + word_score.word + "\n"
		await $Timer.timeout
		$Scores.text = $Scores.text + str(word_score.score) + "\n"
		await $Timer.timeout
