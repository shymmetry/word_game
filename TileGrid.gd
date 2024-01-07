extends Area2D

const tile_scene = preload("res://tile.tscn")
const word_pop = preload("res://word_pop.tscn")
const EnglishDict = preload("res://scripts/dict.gd")
const Letters = preload("res://const/letters.gd")

var letter_picker_freq_total = 0
var words = EnglishDict.new().words
var exploding_points = {}
var exploding_tiles_done = 0
var dropping_tiles_done = 0

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
	Signals.connect('StartGame', reset)
	Signals.connect('FindAndRemoveWords', remove_all_words)

func init_tiles():
	Globals.tiles = []
	for col in range(0, Globals.cols):
		var tile_col = []
		
		for row in range(0, Globals.rows):
			var tile = create_tile(col, row)
			tile_col.append(tile)
			
		Globals.tiles.append(tile_col)

func reset():
	$"../../GameOverCL/GameOver".hide()
	get_tree().reload_current_scene()

func remove_all_words():
	print("Checking for words")
	Globals.idle = false
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
			var tile = Globals.tiles[point.x][point.y]
			tile.explode()
			exploding_tiles_done += 1
			Globals.tiles[point.x][point.y] = null
	else:
		# The effective end of the word checking loop.
		if Globals.swaps <= 0:
			$"../../GameOverCL/GameOver/VBoxContainer/Score".text = "Score: %s" % Globals.score
			$"../../GameOverCL/GameOver".show()
		Globals.idle = true

func center_of_points(points):
	var point1 = points[0]
	var point2 = points[points.size()-1]
	# Get the average of the first and last nodes to get the middle. Add
	# 1 to center the point.
	# Subtract half of size from the end to center
	# Add half of padding to account for sides of tile grid
	var x = (abs(point1.x+point2.x+1)/2.0)*(Globals.tile_size+Globals.padding)-40+Globals.padding/2
	var y = (abs(point1.y+point2.y+1)/2.0)*(Globals.tile_size+Globals.padding)-20+Globals.padding/2
	return Vector2(x, y)

func explode_finished():
	exploding_tiles_done -= 1
	if exploding_tiles_done == 0:
		# Remove exploded tiles
		for removed_point in exploding_points:
			Globals.tiles[removed_point.x][removed_point.y] == null
		
		# Add tiles to top
		var new_tiles = populate_tiles(exploding_points)
		
		drop_tiles(exploding_points, new_tiles)

func populate_tiles(removed_points: Dictionary):
	# Adds new tiles for each given removed point. The created tiles are placed
	# in new negative y rows.
	var col_totals = []; col_totals.resize(Globals.cols); col_totals.fill(0)
	for removed_point in removed_points:
		col_totals[removed_point.x] += 1
	
	var new_tiles = []
	for col in Globals.cols:
		var new_tiles_col = []
		for row in range(0, col_totals[col]):
			var tile = create_tile(col, row, true)
			new_tiles_col.append(tile)
		
		new_tiles.append(new_tiles_col)
	
	return new_tiles

func drop_tiles(removed_points: Dictionary, new_tiles: Array):
	# 2D array of the number of spaces each tile needs to drop
	var drops = []
	for i in range(0, Globals.cols):
		var col = []; col.resize(Globals.rows); col.fill(0)
		drops.append(col)
	
	# Calculate the number of spaces each tile must fall.
	for removed_point in removed_points:
		# Drop every space above a removed point
		for y in range(0, removed_point.y):
			drops[removed_point.x][y] = drops[removed_point.x][y] + 1
	
	# Drop the tiles
	dropping_tiles_done = 0
	for col in range(0, Globals.cols):
		for row in range(Globals.rows-1, -1, -1):
			var drop = drops[col][row]
			var tile = Globals.tiles[col][row]
			
			if tile and drop > 0: 
				tile.drop(drop*(Globals.tile_size+Globals.padding))
				dropping_tiles_done += 1
				tile.row = row+drop
				Globals.tiles[col][row] = null
			Globals.tiles[col][row+drop] = tile
		
		var new_tiles_col = new_tiles[col]
		for i in range(0, new_tiles_col.size()):
			var new_tile = new_tiles_col[i]
			new_tile.drop(new_tiles_col.size()*(Globals.tile_size+Globals.padding))
			dropping_tiles_done += 1
			
			var row = new_tiles_col.size()-1-i
			Globals.tiles[col][new_tiles_col.size()-1-i] = new_tile
			
			new_tile.row = row

func drop_finished():
	dropping_tiles_done -= 1
	if dropping_tiles_done == 0:
		# Loop word removal
		remove_all_words()

func get_all_words():
	# Gets all the words on the board starting from any letter
	var found = []
	for col in range(0, Globals.cols):
		for row in range(0, Globals.rows):
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
		1: xrange = range(x, Globals.cols)
	match ydif:
		-1: yrange = range(y, -1, -1)
		0: yrange = [y]
		1: yrange = range(y, Globals.rows)
	for col in xrange:
		for row in yrange:
			str += get_letter(col, row)
	
	var longest_str = get_longest_word(str)
	if !longest_str: return null
	
	for i in range(0, longest_str.length()):
		points.append({"x": x+(i*xdif), "y": y+(i*ydif)})
	return {"str": longest_str, "points": points}

func get_letter(x: int, y: int):
	return Globals.tiles[x][y].get_node("Letter").text

func get_longest_word(str: String):
	if str.length() < Globals.min_word_length: return null
	for len in range(str.length(), Globals.min_word_length-1, -1):
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
	
	var x = Globals.padding*(col + 1) + col*Globals.tile_size
	var y = 0
	if new: y = -1 * (Globals.padding*(row) + (row + 1)*Globals.tile_size)
	else: y = Globals.padding*(row + 1) + row*Globals.tile_size
	
	tile.position = Vector2(x, y)
	var char = rand_char()
	tile.get_node("Letter").text = char
	tile.get_node("Score").text = str(Letters.letter_scores.get(char))
	tile.col = col
	tile.row = row

	add_child(tile)
	return tile

func print_tiles():
	var tile_letters = []
	for col in range(0, Globals.cols):
		var tile_letters_col = []
		for row in range(0, Globals.rows):
			tile_letters_col.append(get_letter(col, row))
		tile_letters.append(tile_letters_col)
	print(tile_letters)
