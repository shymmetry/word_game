extends Panel

func _process(_delta):
	var minutes = Globals.seconds_left / 60
	var seconds = Globals.seconds_left % 60
	$Margins/HBox/Value.text = "%d:%02d" % [minutes, seconds]
