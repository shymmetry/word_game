extends Node

# Constants
const num_levels = 6

# Game variables
var tiles = []
var score = 0
var progress = 0
var swaps = 1
var matched_words = []

var board_changed = false
var idle = true

var selected_tile = null
var dragged_tiles = []

var current_level = 0
var level_data = null
