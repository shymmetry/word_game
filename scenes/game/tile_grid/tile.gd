extends Panel

@onready var animation = $AnimationPlayer

# GAME MUST UPDATE THESE
var row = -1
var col = -1

var tile_style = preload("res://tres/tile.tres")
var tile_clicked_style = preload("res://tres/tile_clicked.tres")
var tile_dragged_style = preload("res://tres/tile_dragged.tres")

func set_letter(letter: String):
	$Letter.text = letter

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var stylebox = self.get_theme_stylebox("panel")
	if Globals.selected_tile == self:
		if stylebox != tile_clicked_style:
			self.add_theme_stylebox_override("panel", tile_clicked_style)
	elif Globals.dragged_tiles.has(self):
		if stylebox != tile_dragged_style:
			self.add_theme_stylebox_override("panel", tile_dragged_style)
	else:
		if stylebox != tile_style:
			self.add_theme_stylebox_override("panel", tile_style)
