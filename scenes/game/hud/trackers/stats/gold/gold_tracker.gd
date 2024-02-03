extends Panel

func _process(_delta):
	$"Margins/HBox/Value".text = str(Globals.score)
