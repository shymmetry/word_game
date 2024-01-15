extends Node
class_name WordTiles

var word = null
var tiles = []

func _init(wordi: String, tilesi: Array[Tile]):
	word = wordi
	tiles = tilesi
