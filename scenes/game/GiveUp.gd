extends VBoxContainer

func _on_back_button_pressed():
	Sounds.click()
	get_parent().get_parent().hide()

func _on_confirm_button_pressed():
	Sounds.click()
	Signals.emit_signal("GameOver")
	get_parent().get_parent().hide()
	get_parent().get_parent().get_parent().get_node("GameOverCL").show()
