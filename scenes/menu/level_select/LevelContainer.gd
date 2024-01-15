extends Container

const level_scene = preload("res://scenes/menu/level_select/level.tscn")

func _init():
	# Add endless
	var endless = level_scene.instantiate()
	endless.level = 0
	
	var endless_user_data = UserData.completed_levels.get("0")
	var high_score = endless_user_data.high_score if endless_user_data else 0
	
	endless.get_node("Container/Level").text = str("Endless")
	endless.get_node("Container/Level").add_theme_font_size_override("font_size", 18)
	endless.get_node("Container/Subtext").text = "Best: %s" % high_score
	endless.get_node("Container/Subtext").add_theme_font_size_override("font_size", 10)
	add_child(endless)
	
	# Add normal levels
	for num_level in range(1, Levels.num_levels() + 1):
		var user_data = UserData.completed_levels.get(str(num_level))
		var level = level_scene.instantiate()
		
		level.level = num_level
		level.get_node("Container/Level").text = str(num_level)
		level.get_node("Container/Subtext").hide()
		
		var highest_level_won = UserData.completed_levels.keys().max()
		highest_level_won = 0 if highest_level_won == null else highest_level_won
		var playable = num_level == 1 or user_data != null or num_level == (int(highest_level_won) + 1)
		level.disabled = !playable
		
		add_child(level)
