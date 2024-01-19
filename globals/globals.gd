extends Node

# Constants
const all_letters = "ETAOINSRUDLHCMFYWGPBVKXQJZ" # ordered by frequency for speed

# Game variables
var game_mode = null
var rows = 6
var cols = 6
var tiles = []
var score = 0
var swaps = 1
var hints = 1
var matched_words = []

var board_changed = false
var idle = true

var selected_tile = null
var dragged_tiles: Array[Tile] = []
var hint_tiles = []

var current_level = 0
var level_data = null
