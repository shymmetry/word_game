extends Container

const level_scene = preload("res://scenes/menu/level_select/level.tscn")

func _init():
	for num_level in range(1, Globals.num_levels + 1):
		var user_data = UserData.completed_levels.get(str(num_level))
		var level = level_scene.instantiate()
		
		level.level = num_level
		level.get_node("Level").text = "Level %s" % num_level
		
		var highest_level_won = UserData.completed_levels.keys().max()
		highest_level_won = 0 if highest_level_won == null else highest_level_won
		var playable = num_level == 1 or user_data != null or num_level == (int(highest_level_won) + 1)
		level.disabled = !playable
		
		add_child(level)
