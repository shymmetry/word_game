extends Panel

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if Globals.resets >= 1: $Box/Margin/Ticks/PowerTick.on()
	else: $Box/Margin/Ticks/PowerTick.off()
	if Globals.resets >= 2: $Box/Margin/Ticks/PowerTick2.on()
	else: $Box/Margin/Ticks/PowerTick2.off()
	if Globals.resets >= 3: $Box/Margin/Ticks/PowerTick3.on()
	else: $Box/Margin/Ticks/PowerTick3.off()

func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		if Globals.resets > 0:
			Globals.resets -= 1
			Signals.emit_signal("ResetBoard")
