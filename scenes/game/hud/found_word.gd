extends Label

var found_word_index: int

func _process(_delta):
	if Globals.matched_words.size() > found_word_index:
		self.text = Globals.matched_words[found_word_index].word
	else:
		self.text = ""
	
	if found_word_index >= Globals.round_data.word_cnt_goal:
		self.hide()
	else:
		self.show()
