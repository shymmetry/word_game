extends VBoxContainer

const letters_alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ?"
const table_cell = preload("res://scenes/game/modal/main/table_cell.tscn")


func _ready():
	_reset()
	Signals.connect("StartRound", _reset)

func _reset():
	_free_all_children()
	var letter_probs = LetterUtil.get_letter_probabilities()
	for letter in letters_alpha:
		var prob = letter_probs.get(letter)
		var display_prob = snapped(prob, 0.001) * 100
		
		var new_cell = table_cell.instantiate()
		new_cell.set_cell(letter, "%.1f%%" % display_prob)
		new_cell.set_v_size_flags(SIZE_EXPAND)
		add_child(new_cell)

func _free_all_children() -> void:
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
