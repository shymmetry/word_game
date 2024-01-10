extends Button

func _ready():
	pressed.connect(self._button_pressed)

func _button_pressed():
	Levels.set_current_level(Globals.current_level + 1)
	Signals.emit_signal("StartGame")
