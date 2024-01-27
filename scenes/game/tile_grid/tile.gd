extends Control
class_name Tile

@onready var animation = $"Body/AnimationPlayer"

# GAME MUST UPDATE THESE
var row = -1
var col = -1
var tile_type = E.TILE_TYPE.NORMAL
var letter = "?"
var score = ""
var damage = 0

var normal_base_style = preload("res://styles/tile/base/tile_normal.tres")
var harden_base_style = preload("res://styles/tile/base/tile_harden.tres")
var mult_base_style = preload("res://styles/tile/base/tile_multiplier.tres")
var clicked_overlay_style = preload("res://styles/tile/overlay/tile_clicked_overlay.tres")
var normal_overlay_style = preload("res://styles/tile/overlay/tile_normal_overlay.tres")
var dragged_overlay_style = preload("res://styles/tile/overlay/tile_dragged_overlay.tres")
var clicked_underlay_style = preload("res://styles/tile/underlay/tile_clicked_underlay.tres")
var normal_underlay_style = preload("res://styles/tile/underlay/tile_normal_underlay.tres")

func _ready():
	if damage >= 1: $Body/Footer/Gun1.show()
	if damage >= 2: $Body/Footer/Gun2.show()
	if damage >= 3: $Body/Footer/Gun3.show()
	if damage >= 4: $Body/Footer/Gun4.show()
	if damage >= 5: $Body/Footer/Gun5.show()

func _process(_delta):
	$"Body/Letter".text = self.letter
	$"Body/Score".text = self.score
	
	# Handle overlay / underlay from tile state
	if Globals.selected_tile == self:
		update_stylebox($"Body/Overlay", clicked_overlay_style)
		update_stylebox($"Body/Underlay", clicked_underlay_style)
	elif Globals.dragged_tiles.has(self):
		update_stylebox($"Body/Overlay", dragged_overlay_style)
		update_stylebox($"Body/Underlay", normal_underlay_style)
	else:
		update_stylebox($"Body/Overlay", normal_overlay_style)
		update_stylebox($"Body/Underlay", normal_underlay_style)
	
	# Handle base style from tile type
	var base_style: StyleBoxFlat = null
	match tile_type:
		E.TILE_TYPE.NORMAL:
			base_style = normal_base_style
		E.TILE_TYPE.MULTIPLIER:
			base_style = mult_base_style
		E.TILE_TYPE.HARDENED:
			base_style = harden_base_style
	update_stylebox($"Body/Base", base_style)
	
	# Handle animations
	if Globals.hint_tiles.has(self) and !animation.current_animation:
		animation.play('hint')
	elif !Globals.hint_tiles.has(self) and animation.current_animation == "hint":
		animation.stop()

func set_letter(new_letter: String):
	self.letter = new_letter
	var new_score = Globals.level_data.letter_scores.get(new_letter)
	self.score = str(new_score) if new_score > 0 else ""

func explode():
	animation.play("explode")

func drop(tiles: int):
	var tween = create_tween()
	var new_position = Vector2(self.position.x, self.position.y+tiles*self.size.y)
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

func _hint_sound():
	Sounds.hint()
