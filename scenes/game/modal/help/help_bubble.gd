extends PanelContainer

func set_text(text: String) -> void:
	$VBoxContainer/Label.text = text

func _on_button_pressed():
	Signals.emit_signal("TutorialNext")
