extends Label

var seconds_left = 0

func _ready():
	_reset_timer()
	Signals.connect('StartGame', func(): $Timer.start(1))
	Signals.connect('ResetTimer', _reset_timer)

func _process(_delta):
	var minutes = seconds_left / 60
	var seconds = seconds_left % 60
	text = "%d:%02d" % [minutes, seconds]

func _reset_timer():
	seconds_left = Globals.level_data.time_seconds

func _on_timer_timeout():
	seconds_left -= 1
	if seconds_left == 0:
		$Timer.stop()
		Signals.emit_signal("TimedOut")
