extends Label

@onready var animation = $AnimationPlayer

func reset():
	animation.play("loading")

func _ready():
	reset()

func set_error():
	animation.stop()
	self.text = "Oops, we're unable to write the poem at this time"
	Signals.emit_signal("StartWordScoring")

func set_poem(poem: String):
	animation.stop()
	self.text = ""
	$Timer.set_wait_time(0.1)
	$Timer.start()
	
	var words = poem.split(" ")
	for word in words:
		self.text = self.text + word + " "
		await $Timer.timeout
	Signals.emit_signal("StartWordScoring")
