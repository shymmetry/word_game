extends CanvasLayer

func _on_button_left_pressed():
	Sounds.click()
	Signals.emit_signal("GameOver")
	self.hide()

func _on_button_right_pressed():
	Sounds.click()
	self.hide()
