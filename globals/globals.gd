extends Node

# Constants
const all_letters = "ETAOINSRUDLHCMFYWGPBVKXQJZ" # ordered by frequency for speed
const max_letters = 4

# Game data
var tiles = [] # 2D array of all tiles in play
var matched_words = []
var life: int
var score: int
var max_energy: int
var energy: int
var shop_refresh_cost: int

# Game state
var idle = true
var paused = false
var round_over = false
var wild_selected = false

# Tile state
var selected_tile = null
var dragged_tiles: Array[Tile] = []
var hint_tiles = []

# Round info
var current_round = 0
var round_data = null
var difficulty: Difficulty
var character: Character

func cols():
	if round_data == null: return null
	return round_data.board.size()

func rows():
	if round_data == null: return null
	return round_data.board[0].size()

# Player data
var items = {}
