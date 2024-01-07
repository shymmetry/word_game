extends Panel

@onready var animation = $AnimationPlayer

# GAME MUST UPDATE THESE
var row = -1
var col = -1

func set_letter(char: String):
	$Letter.text = char

func explode():
	animation.play("explode")

func drop(pixels: int):
	var tween = create_tween()
	var new_position = Vector2(self.position.x, self.position.y+pixels)
	tween.tween_property(self, "position", new_position, 0.5)
	tween.tween_callback(func(): Signals.emit_signal("DropFinished"))

func explode_finished():
	Signals.emit_signal("ExplodeFinished")
	destroy()

func destroy():
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
