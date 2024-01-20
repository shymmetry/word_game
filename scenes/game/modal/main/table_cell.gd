extends Control

func set_cell(letter: String, value: String):
	$TableCell/Content/Letter.text = letter
	$TableCell/Content/Value.text = value
