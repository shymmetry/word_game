extends Label

func _process(_delta):
	self.text = "%d/%d" % [Globals.energy, Globals.max_energy]
