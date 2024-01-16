extends Control

func _on_back_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")
