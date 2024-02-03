extends Panel

var pressed_style = preload("res://styles/trackers/power_tracker_pressed.tres")
var tracker_style = preload("res://styles/trackers/power_tracker.tres")

func _process(_delta):
	var stylebox = get_theme_stylebox("panel")
	var new_stylebox = pressed_style if Globals.wild_selected else tracker_style
	if stylebox != new_stylebox:
		add_theme_stylebox_override("panel", new_stylebox)

func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed \
			and !Globals.paused:
		
		if Globals.selected_tile:
			var done = PowerUtil.wild(Globals.selected_tile)
			if !done: Sounds.error()
			return
		
		if Globals.energy >= 5 and !Globals.wild_selected:
			Globals.wild_selected = true
		elif Globals.wild_selected:
			Globals.wild_selected = false
