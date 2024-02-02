extends Control

var _selected_difficulty_index: int
var _selected_game_type_index: int

func _ready():
	_selected_difficulty_index = 0
	_set_difficulty(Difficulties.difficulty_progression[_selected_difficulty_index])
	_selected_game_type_index = 0

func _set_difficulty(difficulty: Difficulty):
	if difficulty == Difficulties.difficulty_progression.front():
		$Margin/Content/DifficultySelector/DifficultyLeft.disabled = true
	else:
		$Margin/Content/DifficultySelector/DifficultyLeft.disabled = false
	
	if difficulty == Difficulties.difficulty_progression.back():
		$Margin/Content/DifficultySelector/DifficultyRight.disabled = true
	else:
		$Margin/Content/DifficultySelector/DifficultyRight.disabled = false
	
	$Margin/Content/DifficultySelector/Difficulty.text = difficulty.display_name
	$Margin/Content/DifficultyDescription.text = difficulty.description

func _on_back_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")

func _on_play_button_pressed():
	Sounds.click()
	Levels.set_current_round(1)
	Levels.set_difficulty(Difficulties.difficulty_progression[_selected_difficulty_index])
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

func _on_difficulty_left_pressed():
	_selected_difficulty_index = _selected_difficulty_index - 1
	_set_difficulty(Difficulties.difficulty_progression[_selected_difficulty_index])

func _on_difficulty_right_pressed():
	_selected_difficulty_index = _selected_difficulty_index + 1
	_set_difficulty(Difficulties.difficulty_progression[_selected_difficulty_index])
