extends CanvasLayer

func _process(_delta):
	$"Background/Details/Label".text = "Score: %s" % Globals.score

func _on_button_left_pressed():
	Sounds.click()
	Signals.emit_signal("StartGame")

func _on_button_right_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")
