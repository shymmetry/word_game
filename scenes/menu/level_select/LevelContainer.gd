extends Container

const level_scene = preload("res://scenes/menu/level_select/level.tscn")

func _init():
	print(UserData.completed_levels)
	for num_level in range(1, Globals.num_levels + 1):
		var user_data = UserData.completed_levels.get(str(num_level))
		var level = level_scene.instantiate()
		
		level.level = num_level
		level.get_node("Level").text = "Level %s" % num_level
		print(user_data == null)
		level.disabled = user_data == null
		
		add_child(level)
