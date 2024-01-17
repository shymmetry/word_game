extends Panel

var on_click_signal = ""

func set_icon(icon_path: String):
	$Icon.texture = load(icon_path)

func set_value(value: String):
	$Value.text = value

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		Signals.emit_signal(on_click_signal)
