extends Control

func _on_button_pressed():
	Signals.emit_signal("NextRound")
