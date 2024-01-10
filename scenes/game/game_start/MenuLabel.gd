extends Label

func _ready():
	self.text = "Level %s" % Globals.current_level
