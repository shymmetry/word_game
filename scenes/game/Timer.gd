extends Timer

func _ready():
	_reset_timer()
	Signals.connect('StartRound', func(): _reset_timer())

func _reset_timer():
	self.start(1)
	Globals.seconds_left = Globals.round_time

func _on_timeout():
	if !Globals.paused:
		Globals.seconds_left -= 1
		if Globals.seconds_left == 0:
			self.stop()
			Signals.emit_signal("TimedOut")
		elif Globals.seconds_left <= 10:
			Sounds.timer()
