extends Node

const tile_size = 60
const padding = 10
const min_word_length = 4

# Game variables
var tiles = []
var score = 0
var swaps = 1
var idle = false

# Session variables
var current_level = 0
var level_data = null
func set_current_level(level: int):
	current_level = level
	level_data = load("res://const/levels/level%s.gd" % level)

# Player variables
var high_score = 0
var completed_levels = []
