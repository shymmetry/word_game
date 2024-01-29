extends Node
class_name ScoreResults

var word = null
var tiles = null
var score = null

func _init(_word: String, _tiles: Array[Tile], _score: int):
	word = _word
	tiles = _tiles
	score = _score
