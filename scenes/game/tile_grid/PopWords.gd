extends Control

const word_pop = preload("res://scenes/game/word_pop/word_pop.tscn")

func _ready():
	Signals.connect("WordScored", _word_pop)

func _word_pop(score_results: ScoreResults):
	# Handle word pop
	var new_word_pop = word_pop.instantiate()
	new_word_pop.update_text(score_results.word, score_results)
	var center = _center_of_points(score_results.tiles)
	new_word_pop.set_position(center)
	add_child(new_word_pop)

func _center_of_points(tiles: Array[Tile]):
	var minx = 9999999
	var maxx = 0
	var miny = 9999999
	var maxy = 0
	var tile_size = tiles[0].size
	for tile in tiles:
		minx = min(minx, tile.global_position.x)
		maxx = max(maxx, tile.global_position.x)
		miny = min(miny, tile.global_position.y)
		maxy = max(maxy, tile.global_position.y)
	
	var x = minx+(maxx-minx)/2+tile_size.x/2
	var y = miny+(maxy-miny)/2+tile_size.y/2
	
	return Vector2(x, y)
