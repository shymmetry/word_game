extends Button

var level = 0

func _ready():
	pressed.connect(self._button_pressed)

func _button_pressed():
	Sounds.click()
	Levels.set_current_level(level)
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
