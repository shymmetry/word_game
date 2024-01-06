extends CanvasLayer

func update_word(word: String):
	$"WordPop/Word".text = word

func set_position(point):
	$WordPop.position.x = point.x
	$WordPop.position.y = point.y
