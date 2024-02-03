extends CanvasLayer

func _ready():
	$"Background/VBox/Title/Margin/Label".text = "Menu"

func _on_button_left_pressed():
	Sounds.click()
	UserData.seen_tutorial = false
	self.hide()
	Signals.emit_signal("StartTutorial")

func _on_button_middle_pressed():
	Sounds.click()
	Signals.emit_signal("ResetGame")

func _on_back_pressed():
	Sounds.click()
	if !Globals.round_over:
		Globals.paused = false
	self.hide()

func _on_button_right_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")
