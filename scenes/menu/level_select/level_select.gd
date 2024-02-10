extends Control

var _selected_character_index: int
var _selected_difficulty_index: int

func _ready():
	_selected_character_index = 0
	_set_character(Characters.character_progression[_selected_character_index])

func _highest_unlocked_difficulty(character: Character) -> Difficulty:
	if UserData.difficulty_unlocks.has(character.display_name):
		var unlocked = UserData.difficulty_unlocks[character.display_name]
		if unlocked > Difficulties.difficulty_progression.size():
			return Difficulties.difficulty_progression.back()
		return Difficulties.difficulty_progression[unlocked]
	return Difficulties.difficulty_progression.front()

func _set_character(character: Character):
	$Margin/Content/CharacterSelector/CharacterLeft.disabled = character == Characters.character_progression.front()
	$Margin/Content/CharacterSelector/CharacterRight.disabled = character == Characters.character_progression.back()

	$Margin/Content/CharacterSelector/Character.text = character.display_name
	$Margin/Content/CharacterDescription.text = character.description
	
	_set_difficulty(_highest_unlocked_difficulty(character))

func _set_difficulty(difficulty: Difficulty):
	_selected_difficulty_index = Difficulties.difficulty_progression.find(difficulty)
	$Margin/Content/DifficultySelector/DifficultyLeft.disabled = difficulty == Difficulties.difficulty_progression.front()
	$Margin/Content/DifficultySelector/DifficultyRight.disabled = difficulty == _highest_unlocked_difficulty(Characters.character_progression[_selected_character_index])
	
	$Margin/Content/DifficultySelector/Difficulty.text = difficulty.display_name
	$Margin/Content/DifficultyDescription.text = difficulty.description

func _on_back_pressed():
	Sounds.click()
	get_tree().change_scene_to_file("res://scenes/menu/main/menu.tscn")

func _on_play_button_pressed():
	Sounds.click()
	Levels.set_current_round(1)
	Levels.set_character(Characters.character_progression[_selected_character_index])
	Levels.set_difficulty(Difficulties.difficulty_progression[_selected_difficulty_index])
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

func _on_difficulty_left_pressed():
	_set_difficulty(Difficulties.difficulty_progression[_selected_difficulty_index - 1])

func _on_difficulty_right_pressed():
	_set_difficulty(Difficulties.difficulty_progression[_selected_difficulty_index + 1])

func _on_character_left_pressed():
	_selected_character_index = _selected_character_index - 1
	_set_character(Characters.character_progression[_selected_character_index])

func _on_character_right_pressed():
	_selected_character_index = _selected_character_index + 1
	_set_character(Characters.character_progression[_selected_character_index])
