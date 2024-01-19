extends Panel

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	$"Margins/HBox/Value".text = str(Globals.swaps)

func _on_gui_input(event):
	Signals.emit_signal("HintRequested")
