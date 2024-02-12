extends Node

func save_game():
	var save_data = UserData.save_data()
	var json_string = JSON.stringify(save_data)
	
	var save = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var save = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save.get_position() < save.get_length():
		var json_string = save.get_line()
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		# Get the data from the JSON object
		var node_data = json.get_data()
		print(node_data)
		UserData.load_data(node_data)
		
