extends ProgressBar

func _process(_delta):
	self.max_value = Globals.max_energy
	self.value = Globals.energy
