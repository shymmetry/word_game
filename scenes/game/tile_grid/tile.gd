extends Control
class_name Tile

@onready var animation = $AnimationPlayer

# GAME MUST UPDATE THESE
var row = -1
var col = -1
var tile_type = E.TILE_TYPE.NORMAL

var normal_base_style = preload("res://tres/tile/base/tile_normal.tres")
var harden_base_style = preload("res://tres/tile/base/tile_harden.tres")
var clicked_overlay_style = preload("res://tres/tile/overlay/tile_clicked_overlay.tres")
var normal_overlay_style = preload("res://tres/tile/overlay/tile_normal_overlay.tres")
var dragged_overlay_style = preload("res://tres/tile/overlay/tile_dragged_overlay.tres")
var clicked_underlay_style = preload("res://tres/tile/underlay/tile_clicked_underlay.tres")
var normal_underlay_style = preload("res://tres/tile/underlay/tile_normal_underlay.tres")

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

func _process(_delta):
	if Globals.selected_tile == self:
		update_stylebox($Overlay, clicked_overlay_style)
		update_stylebox($Underlay, clicked_underlay_style)
	elif Globals.dragged_tiles.has(self):
		update_stylebox($Overlay, dragged_overlay_style)
		update_stylebox($Underlay, normal_underlay_style)
	else:
		update_stylebox($Overlay, normal_overlay_style)
		update_stylebox($Underlay, normal_underlay_style)
	
	match tile_type:
		E.TILE_TYPE.NORMAL:
			update_stylebox($Base, normal_base_style)
		E.TILE_TYPE.HARDENED:
			update_stylebox($Base, harden_base_style)

func update_stylebox(panel: Panel, new_stylebox: StyleBoxFlat):
	var stylebox = panel.get_theme_stylebox("panel")
	if stylebox != new_stylebox:
		panel.add_theme_stylebox_override("panel", new_stylebox)
