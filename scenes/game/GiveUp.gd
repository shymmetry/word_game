extends VBoxContainer

func _on_back_button_pressed():
	get_parent().get_parent().hide()

func _on_confirm_button_pressed():
	Signals.emit_signal("GameOver")
	get_parent().get_parent().hide()
	get_parent().get_parent().get_parent().get_node("GameOverCL").show()
