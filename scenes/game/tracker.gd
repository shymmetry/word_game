extends Panel

func set_icon(icon_path: String):
	$Icon.texture = load(icon_path)

func set_value(value: int):
	$Value.text = str(value)
