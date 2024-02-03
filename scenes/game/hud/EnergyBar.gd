extends ProgressBar

func _process(delta):
	self.max_value = Globals.max_energy
	self.value = Globals.energy
