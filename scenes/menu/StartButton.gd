extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(self._button_pressed)

func _button_pressed():
	Globals.set_current_level(1)
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
