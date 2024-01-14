extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Store.load_game()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/level_select/level_select.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/settings/settings.tscn")

func _on_how_to_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/how_to/how_to.tscn")

func _on_quit_pressed():
	get_tree().quit()
