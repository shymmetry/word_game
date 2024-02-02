extends Panel

var pressed_style = preload("res://styles/trackers/power_tracker_pressed.tres")
var tracker_style = preload("res://styles/trackers/power_tracker.tres")

func _process(_delta):
	if Globals.wilds >= 1: $Box/Margin/Ticks/PowerTick.on()
	else: $Box/Margin/Ticks/PowerTick.off()
	if Globals.wilds >= 2: $Box/Margin/Ticks/PowerTick2.on()
	else: $Box/Margin/Ticks/PowerTick2.off()
	if Globals.wilds >= 3: $Box/Margin/Ticks/PowerTick3.on()
	else: $Box/Margin/Ticks/PowerTick3.off()
	
	var stylebox = get_theme_stylebox("panel")
	var new_stylebox = pressed_style if Globals.wild_selected else tracker_style
	if stylebox != new_stylebox:
		add_theme_stylebox_override("panel", new_stylebox)

func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		if Globals.wilds > 0 and !Globals.wild_selected:
			Globals.wild_selected = true
		elif Globals.wild_selected:
			Globals.wild_selected = false
