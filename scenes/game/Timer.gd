extends Timer

func _ready():
	# No need to initialize for endless games
	if Globals.game_mode != E.GAME_TYPE.ENDLESS:
		_reset_timer()
		Signals.connect('StartGame', func(): self.start(1))
		Signals.connect('ResetTimer', _reset_timer)

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
