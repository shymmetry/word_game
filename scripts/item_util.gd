extends Node

const stored_items = preload("res://static/items.gd")

var items = []

func _ready():
	var config_map = stored_items.new().get_all_items()
	for key in config_map:
		items.append(config_map[key])

func get_random_items(num: int, duplicates: bool) -> Array[Item]:
	var selected_items: Array[Item] = []
	var items_left = items.duplicate()
	for i in range(0, num):
		var rand = randi() % items_left.size()
		selected_items.append(items_left[rand])
		if !duplicates:
			items_left.remove_at(rand)
	return selected_items
