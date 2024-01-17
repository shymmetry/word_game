extends Control
class_name Tile

@onready var animation = $AnimationPlayer

# GAME MUST UPDATE THESE
var row = -1
var col = -1
var tile_type = E.TILE_TYPE.NORMAL
var letter = "?"
var score = ""

var normal_base_style = preload("res://tres/tile/base/tile_normal.tres")
var harden_base_style = preload("res://tres/tile/base/tile_harden.tres")
var mult_base_style = preload("res://tres/tile/base/tile_multiplier.tres")
var clicked_overlay_style = preload("res://tres/tile/overlay/tile_clicked_overlay.tres")
var normal_overlay_style = preload("res://tres/tile/overlay/tile_normal_overlay.tres")
var dragged_overlay_style = preload("res://tres/tile/overlay/tile_dragged_overlay.tres")
var clicked_underlay_style = preload("res://tres/tile/underlay/tile_clicked_underlay.tres")
var normal_underlay_style = preload("res://tres/tile/underlay/tile_normal_underlay.tres")

func set_letter(new_letter: String):
	self.letter = new_letter
	var new_score = Globals.level_data.letter_scores.get(new_letter)
	self.score = str(new_score) if new_score > 0 else ""

func _process(_delta):
	$Letter.text = self.letter
	$Score.text = self.score
	
	if Globals.selected_tile == self:
		update_stylebox($Overlay, clicked_overlay_style)
		update_stylebox($Underlay, clicked_underlay_style)
	elif Globals.dragged_tiles.has(self):
		update_stylebox($Overlay, dragged_overlay_style)
		update_stylebox($Underlay, normal_underlay_style)
	else:
		update_stylebox($Overlay, normal_overlay_style)
		update_stylebox($Underlay, normal_underlay_style)
	
	var base_style: StyleBoxFlat = null
	match tile_type:
		E.TILE_TYPE.NORMAL:
			base_style = normal_base_style
		E.TILE_TYPE.MULTIPLIER:
			base_style = mult_base_style
		E.TILE_TYPE.HARDENED:
			base_style = harden_base_style
	if Globals.hint_tiles.has(self):
		base_style = base_style.duplicate()
		base_style.border_color = Color(255, 215, 0) #gold
		base_style.border_width_left = 2
		base_style.border_width_right = 2
		base_style.border_width_top = 2
		base_style.border_width_bottom = 2
	update_stylebox($Base, base_style)

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

func update_stylebox(panel: Panel, new_stylebox: StyleBoxFlat):
	var stylebox = panel.get_theme_stylebox("panel")
	if stylebox != new_stylebox:
		panel.add_theme_stylebox_override("panel", new_stylebox)
