extends Area2D

const tile_scene = preload("res://tile.tscn")
const word_pop = preload("res://word_pop.tscn")
const EnglishDict = preload("res://scripts/dict.gd")
const Letters = preload("res://const/letters.gd")

const rows = 6
const cols = 6
const tile_size = 60
const padding = 10
const min_word_length = 4

var letter_picker_freq_total = 0
var words = EnglishDict.new().words
var tiles = []
var exploding_points = {}
var exploding_tiles_done = 0
var dropping_tiles_done = 0
var idle = false

func _init():
	# Populate letter probability selector
	for letter in Letters.letter_freq:
		var freq = Letters.letter_freq[letter]
		letter_picker_freq_total += freq

# Called when the node enters the scene tree for the first time.
func _ready():
	init_tiles()
	remove_all_words()
	Signals.connect('ExplodeFinished', explode_finished)
	Signals.connect('DropFinished', drop_finished)

func init_tiles():
	for col in range(0, cols):
		var tile_col = []
		
		for row in range(0, rows):
			var tile = create_tile(col, row)
			tile_col.append(tile)
			
		tiles.append(tile_col)

var lifted = null
var lifted_point = null
var lifted_position = null
var swap_tile = null
var swap_position = null
var swap_direction = null

func _input_event(viewport, event, shape_idx):
	# Handle mouse for picking up a tile
	if event is InputEventMouseButton:
		var can_swap = idle and $"../../ScoreArea".can_swap()
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and can_swap:
			lifted_point = get_local_mouse_position()
			lifted = get_tile_at_point(lifted_point)
			lifted_position = lifted.position

func _unhandled_input(event):
	# Handle mouse for putting down a tile
	if event is InputEventMouseButton and not event.pressed:
		if !swap_tile: return
		var xdif = get_local_mouse_position().x - lifted_point.x
		var ydif = get_local_mouse_position().y - lifted_point.y
		var max_dif = max(abs(xdif), abs(ydif))
		var min_dist = (tile_size + padding) / 2
		if max_dif > min_dist:
			var lifted_col = lifted.col
			var lifted_row = lifted.row
			tiles[lifted_col][lifted_row] = swap_tile
			tiles[swap_tile.col][swap_tile.row] = lifted
			lifted.col = swap_tile.col; lifted.row = swap_tile.row
			swap_tile.col = lifted_col; swap_tile.row = lifted_row
			lifted.position = swap_position
			swap_tile.position = lifted_position
			$"../../ScoreArea".count_swap()
			remove_all_words()
		else:
			lifted.position = lifted_position
			swap_tile.position = swap_position
		lifted = null; lifted_point = null; lifted_position = null
		swap_tile = null; swap_position = null; swap_direction = null
	
	# Handle mouse movement for dragging tiles
	if lifted and event is InputEventMouseMotion:
		var xdif = get_local_mouse_position().x - lifted_point.x
		var ydif = get_local_mouse_position().y - lifted_point.y
		if abs(xdif) > abs(ydif):
			if xdif > 0: #right
				if lifted.col == cols - 1: return
				if swap_direction != "right":
					swap_direction = "right"
					if swap_tile:
						swap_tile.position = swap_position
					swap_tile = tiles[lifted.col+1][lifted.row]
					swap_position = swap_tile.position
			else: #left
				if lifted.col == 0: return
				if swap_direction != "left":
					swap_direction = "left"
					if swap_tile:
						swap_tile.position = swap_position
					swap_tile = tiles[lifted.col-1][lifted.row]
					swap_position = swap_tile.position
			var move = min(abs(xdif), tile_size + padding) * sign(xdif)
			lifted.position.x = lifted_position.x + move
			lifted.position.y = lifted_position.y
			swap_tile.position.x = swap_position.x - move
		else:
			if ydif > 0: #down
				if lifted.row == rows - 1: return
				if swap_direction != "down":
					swap_direction = "down"
					if swap_tile:
						swap_tile.position = swap_position
					swap_tile = tiles[lifted.col][lifted.row+1]
					swap_position = swap_tile.position
			else: #up
				if lifted.row == 0: return
				if swap_direction != "up":
					swap_direction = "up"
					if swap_tile:
						swap_tile.position = swap_position
					swap_tile = tiles[lifted.col][lifted.row-1]
					swap_position = swap_tile.position
			var move = min(abs(ydif), tile_size + padding) * sign(ydif)
			lifted.position.x = lifted_position.x
			lifted.position.y = lifted_position.y + move
			swap_tile.position.y = swap_position.y - move

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func remove_all_words():
	print("Checking for words")
	idle = false
	var found_words = get_all_words()
	exploding_points = {}
	for word in found_words:
		$"../../ScoreArea".score_word(word.str)
		
		var new_word_pop = word_pop.instantiate()
		new_word_pop.update_word(word.str)
		# Need to add the parents position since the CanvasLayer of the 
		# word_pop doesn't have (0,0) as it's parents position
		var center = center_of_points(word.points)
		var parent_pos = get_parent().position
		new_word_pop.set_position(center + parent_pos)
		
		add_child(new_word_pop)
		
		for point in word.points:
			exploding_points[point] = null
	
	if exploding_points.size() > 0:
		# Remove all the points that were matched
		for point in exploding_points:
			var tile = tiles[point.x][point.y]
			tile.explode()
			exploding_tiles_done += 1
			tiles[point.x][point.y] = null
	else:
		# The effective end of the word checking loop.
		idle = true

func center_of_points(points):
	var point1 = points[0]
	var point2 = points[points.size()-1]
	# Get the average of the first and last nodes to get the middle. Add
	# 1 to center the point.
	# Subtract half of size from the end to center
	# Add half of padding to account for sides of tile grid
	var x = (abs(point1.x+point2.x+1)/2.0)*(tile_size+padding)-40+padding/2
	var y = (abs(point1.y+point2.y+1)/2.0)*(tile_size+padding)-20+padding/2
	return Vector2(x, y)

func explode_finished():
	exploding_tiles_done -= 1
	if exploding_tiles_done == 0:
		# Remove exploded tiles
		for removed_point in exploding_points:
			tiles[removed_point.x][removed_point.y] == null
		
		# Add tiles to top
		var new_tiles = populate_tiles(exploding_points)
		
		drop_tiles(exploding_points, new_tiles)

func populate_tiles(removed_points: Dictionary):
	# Adds new tiles for each given removed point. The created tiles are placed
	# in new negative y rows.
	var col_totals = []; col_totals.resize(cols); col_totals.fill(0)
	for removed_point in removed_points:
		col_totals[removed_point.x] += 1
	
	var new_tiles = []
	for col in cols:
		var new_tiles_col = []
		for row in range(0, col_totals[col]):
			var tile = create_tile(col, row, true)
			new_tiles_col.append(tile)
		
		new_tiles.append(new_tiles_col)
	
	return new_tiles

func drop_tiles(removed_points: Dictionary, new_tiles: Array):
	# 2D array of the number of spaces each tile needs to drop
	var drops = []
	for i in range(0, cols):
		var col = []; col.resize(rows); col.fill(0)
		drops.append(col)
	
	# Calculate the number of spaces each tile must fall.
	for removed_point in removed_points:
		# Drop every space above a removed point
		for y in range(0, removed_point.y):
			drops[removed_point.x][y] = drops[removed_point.x][y] + 1
	
	# Drop the tiles
	dropping_tiles_done = 0
	for col in range(0, cols):
		for row in range(rows-1, -1, -1):
			var drop = drops[col][row]
			var tile = tiles[col][row]
			
			if tile and drop > 0: 
				tile.drop(drop*(tile_size+padding))
				dropping_tiles_done += 1
				tile.row = row+drop
				tiles[col][row] = null
			tiles[col][row+drop] = tile
		
		var new_tiles_col = new_tiles[col]
		for i in range(0, new_tiles_col.size()):
			var new_tile = new_tiles_col[i]
			new_tile.drop(new_tiles_col.size()*(tile_size+padding))
			dropping_tiles_done += 1
			
			var row = new_tiles_col.size()-1-i
			tiles[col][new_tiles_col.size()-1-i] = new_tile
			
			new_tile.row = row

func drop_finished():
	dropping_tiles_done -= 1
	if dropping_tiles_done == 0:
		# Loop word removal
		remove_all_words()

func get_all_words():
	# Gets all the words on the board starting from any letter
	var found = []
	for col in range(0, cols):
		for row in range(0, rows):
			for dif in [[1,0],[-1,0],[0,1],[0,-1]]:
				var word = get_word(row, col, dif[0], dif[1])
				if word: found.append(word)
	return found

func get_word(x: int, y: int, xdif: int, ydif: int):
	# Gets the longest word starting at a given point and going in a given 
	# direction. If no word is found null is returned.
	var str = ""
	var points = []
	var xrange 
	var yrange
	match xdif:
		-1: xrange = range(x, -1, -1)
		0: xrange = [x]
		1: xrange = range(x, cols)
	match ydif:
		-1: yrange = range(y, -1, -1)
		0: yrange = [y]
		1: yrange = range(y, rows)
	for col in xrange:
		for row in yrange:
			str += get_letter(col, row)
	
	var longest_str = get_longest_word(str)
	if !longest_str: return null
	
	for i in range(0, longest_str.length()):
		points.append({"x": x+(i*xdif), "y": y+(i*ydif)})
	return {"str": longest_str, "points": points}

func get_letter(x: int, y: int):
	return tiles[x][y].get_node("Letter").text

func get_longest_word(str: String):
	if str.length() < min_word_length: return null
	for len in range(str.length(), min_word_length-1, -1):
		var word = str.substr(0, len)
		if is_word(word):
			return word
	return null

func is_word(word: String):
	return words.has(word.to_lower())

func rand_char():
	var rand_num = randi() % letter_picker_freq_total
	var sum = 0
	var selected_letter = "?"
	for letter in Letters.letter_freq:
		sum += Letters.letter_freq[letter]
		if sum >= rand_num:
			selected_letter = letter
			break
	
	return selected_letter

func create_tile(col: int, row: int, new: bool = false):
	var tile = tile_scene.instantiate()
	
	var x = padding*(col + 1) + col*tile_size
	var y = 0
	if new: y = -1 * (padding*(row) + (row + 1)*tile_size)
	else: y = padding*(row + 1) + row*tile_size
	
	tile.position = Vector2(x, y)
	var char = rand_char()
	tile.get_node("Letter").text = char
	tile.get_node("Score").text = str(Letters.letter_scores.get(char))
	tile.col = col
	tile.row = row

	add_child(tile)
	return tile

func get_tile_at_point(position):
	var col = floor((position.x-padding/2) / (tile_size+padding))
	var row = floor((position.y-padding/2) / (tile_size+padding))
	assert(col < cols and row < rows)
	return tiles[col][row]

func print_tiles():
	var tile_letters = []
	for col in range(0, cols):
		var tile_letters_col = []
		for row in range(0, rows):
			tile_letters_col.append(get_letter(col, row))
		tile_letters.append(tile_letters_col)
	print(tile_letters)
