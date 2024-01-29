extends Node

var env_vars: Dictionary = {}

func _ready():
	_load_parsed_env()

func get_var(env_var: String):
	if env_vars.has(env_var):
		return env_vars.get(env_var)
	else:
		return null

func _load_parsed_env() -> void:
	var file = FileAccess.open("res://.env", FileAccess.READ)
	while not file.eof_reached():
		var line: String = file.get_line()
		if line == "":
			continue
		
		var env_var: Array = line.split("=")
		if len(env_var) < 2:
			continue
		
		env_vars[env_var[0]] = env_var[1]

	file.close()
