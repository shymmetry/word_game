extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Sounds.menu_open()
	Store.load_game()

func _on_start_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/level_select/level_select.tscn")

func _on_settings_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/settings/settings.tscn")

func _on_quit_pressed():
	Sounds.click()
	get_tree().quit()
