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

func set_letter(new_letter: String):
	self.letter = new_letter
	var new_score = Globals.level_data.letter_scores.get(new_letter)
	self.score = str(new_score) if new_score > 0 else ""

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

func update_stylebox(panel: Panel, new_stylebox: StyleBoxFlat):
	var stylebox = panel.get_theme_stylebox("panel")
	if stylebox != new_stylebox:
		panel.add_theme_stylebox_override("panel", new_stylebox)

func explode():
	animation.play("explode")

func drop(pixels: int):
	var tween = create_tween()
	var new_position = Vector2(self.position.x, self.position.y+pixels)
	tween.tween_property(self, "position", new_position, 0.5)
	tween.tween_callback(func(): Signals.emit_signal("DropFinished"))

func explode_finished():
	Signals.emit_signal("ExplodeFinished")
	queue_free()

func _on_gui_input(event):
	# Handle mouse for putting down a tile
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and not event.pressed:
		# A tile was selected already for swapping
		if Globals.selected_tile:
			# Only handle if the tile to swap to was clicked and adjacent
			if _is_adjacent(Globals.selected_tile, self) \
					and Globals.swaps > 0:
				_swap_tiles(Globals.selected_tile, self)
				Sounds.swap()
			else:
				if Globals.selected_tile != self:
					Sounds.error()
				Globals.idle = true
			Globals.selected_tile = null
		else:
			# A single tile was selected for swapping
			if !Globals.dragged_tiles and Globals.clicked_tile:
				Globals.selected_tile = self
			# A different tile was selected for word guess
			else:
				if Globals.dragged_tiles.size() >= Globals.level_data.min_word_length:
					Signals.emit_signal("GuessWord")
				else:
					Sounds.error()
					Globals.idle = true
		Globals.clicked_tile = null; Globals.dragged_tiles = []
	
	# Handle mouse for clicking a tile
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed \
			and (Globals.idle or Globals.selected_tile):
		Globals.clicked_tile = self
		Globals.idle = false

func _on_mouse_entered():
	if Globals.clicked_tile and !Globals.selected_tile:
		# Initialize if the drag is starting
		if !Globals.dragged_tiles:
			Globals.dragged_tiles.append(Globals.clicked_tile)
		
		if _is_adjacent(Globals.dragged_tiles.back(), self) \
				and !Globals.dragged_tiles.has(self):
			Globals.dragged_tiles.append(self)
		else:
			# If dragged to an invalid tile, clear
			Globals.clicked_tile = null
			Globals.dragged_tiles = []

func _swap_tiles(tile1, tile2):
	var tile1_col = tile1.col; var tile1_row = tile1.row
	var tile1_position = tile1.position
	Globals.tiles[tile1_col][tile1_row] = tile2
	Globals.tiles[tile2.col][tile2.row] = tile1
	tile1.col = tile2.col; tile1.row = tile2.row
	tile2.col = tile1_col; tile2.row = tile1_row
	Globals.swaps -= 1
	
	# Perform visual swap (prevent other actions while this is happening)
	var tween = create_tween()
	tween.tween_property(tile1, "position", tile2.position, 0.25)
	tween.parallel().tween_property(tile2, "position", tile1_position, 0.25)
	tween.tween_callback(func(): Globals.idle = true; Globals.board_changed = true)

func _is_adjacent(tile1, tile2):
	if tile1 == null or tile2 == null: return false
	var coldif = abs(tile1.col - tile2.col)
	var rowdif = abs(tile1.row - tile2.row)
	return coldif + rowdif == 1
