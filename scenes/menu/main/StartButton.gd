extends Button

func _ready():
	pressed.connect(self._button_pressed)

func _button_pressed():
	Levels.set_current_level(1)
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
