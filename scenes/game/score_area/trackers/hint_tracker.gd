extends Panel

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	$"Margins/HBox/Value".text = str(Globals.hints)

func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		Signals.emit_signal("HintRequested")
