extends Panel

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if Globals.wilds >= 1: $Box/Margin/Ticks/PowerTick.on()
	else: $Box/Margin/Ticks/PowerTick.off()
	if Globals.wilds >= 2: $Box/Margin/Ticks/PowerTick2.on()
	else: $Box/Margin/Ticks/PowerTick2.off()
	if Globals.wilds >= 3: $Box/Margin/Ticks/PowerTick3.on()
	else: $Box/Margin/Ticks/PowerTick3.off()

func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		if Globals.wilds > 0 and !Globals.wild_selected:
			Globals.wild_selected = true
		elif Globals.wild_selected:
			Globals.wild_selected = false
