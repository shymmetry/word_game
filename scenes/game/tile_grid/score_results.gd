extends Node
class_name ScoreResults

var word = null
var tiles = null
var score = null
var bonus_swaps = null
var bonus_hints = null
var bonus_resets = null

func _init(_word: String, _tiles: Array[Tile], _score: int, _bonus_swaps: int, _bonus_hints: int, _bonus_resets: int):
	word = _word
	tiles = _tiles
	score = _score
	bonus_swaps = _bonus_swaps
	bonus_hints = _bonus_hints
	bonus_resets = _bonus_resets
