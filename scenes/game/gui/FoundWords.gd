extends GridContainer

const found_word_scene = preload("res://scenes/game/gui/found_word.tscn")

func _ready():
	for i in range(0, 8):
		var found_word = found_word_scene.instantiate()
		found_word.found_word_index = i
		add_child(found_word)
