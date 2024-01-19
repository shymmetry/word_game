extends Node

var endless_high_score = 0

func save_data():
	var data_map = {}
	for property_info in get_script().get_script_property_list():
		var property_name: String = property_info.name
		if property_name == "user_data.gd": continue
		var property_value = get(property_name)
		data_map[property_name] = property_value
	return data_map

func load_data(data_map):
	for property_info in get_script().get_script_property_list():
		var property_name: String = property_info.name
		if property_name in data_map:
			var property_value = data_map.get(property_name)
			self[property_name] = property_value
