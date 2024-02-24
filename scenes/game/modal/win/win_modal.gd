extends CanvasLayer

func set_unlock(difficulty: Difficulty):
	$Background/VBox/Details/Margin/Label.text = "%s unlocked for %s" % [difficulty.display_name, Globals.character.display_name]

func clear_unlock():
	$Background/VBox/Details/Margin/Label.text = ""

func _on_button_middle_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")
