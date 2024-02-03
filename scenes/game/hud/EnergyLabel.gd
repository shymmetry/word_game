extends Label

func _process(delta):
	self.text = "%d/%d" % [Globals.energy, Globals.max_energy]
