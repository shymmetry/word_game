extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(self._button_pressed)

func _button_pressed():
	Signals.emit_signal("StartGame")
