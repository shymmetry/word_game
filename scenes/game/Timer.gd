extends Timer

func _ready():
	Signals.connect('StartRound', func(): self.start(1))

func _on_timeout():
	if !Globals.paused:
		Globals.seconds_left -= 1
		if Globals.seconds_left == 0:
			self.stop()
			Signals.emit_signal("TimedOut")
		elif Globals.seconds_left <= 10:
			Sounds.timer()
