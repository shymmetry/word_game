extends RichTextLabel

@onready var animation = $AnimationPlayer

func reset():
	animation.play("loading")

func _ready():
	reset()

func set_error():
	animation.stop()
	self.text = "Oops, you're pen melted while writing your poem"
	Signals.emit_signal("StartWordScoring")

func set_poem(poem: String):
	animation.stop()
	self.text = ""
	var matched_words = []
	for word_score in Globals.matched_words: matched_words.append(word_score.word.to_lower())
	
	$Timer.set_wait_time(0.1)
	$Timer.start()
	Sounds.writing()
	
	var words = poem.split(" ")
	var poem_construct = ""
	for word in words:
		var parts = get_all_word_parts(word)
		var word_formatted = ""
		for part in parts:
			if part.to_lower() in matched_words:
				word_formatted = "%s[color=#ffd700]%s[/color]" % [word_formatted, part]
			else:
				word_formatted = "%s%s" % [word_formatted, part]
		
		poem_construct = "%s%s " % [poem_construct, word_formatted]
		self.text = "[center]%s[/center]" % poem_construct
		await $Timer.timeout
	
	Sounds.stop_writing()
	Signals.emit_signal("StartWordScoring")

func get_all_word_parts(word: String) -> Array[String]:
	var regex = RegEx.new()
	regex.compile("[A-Za-z]+|[^A-Za-z]+")
	var results: Array[String] = []
	for result in regex.search_all(word):
		results.push_back(result.get_string())
	return results
