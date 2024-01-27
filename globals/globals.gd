extends Node

# Constants
const all_letters = "ETAOINSRUDLHCMFYWGPBVKXQJZ" # ordered by frequency for speed

# Game data
var game_mode = null
var tiles = [] # 2D array of all tiles in play
var matched_words = []
var score = null
var swaps = null
var hints = null
var life = null
var seconds_left = null
var round_time = null
var last_processed_score_for_increased_difficulty = null

# Game state
var idle = true
var paused = false

# Tile state
var selected_tile = null
var dragged_tiles: Array[Tile] = []
var hint_tiles = []

# Round info
var current_round = 0
var level_data = null

func cols():
	if level_data == null: return null
	return level_data.board.size()

func rows():
	if level_data == null: return null
	return level_data.board[0].size()

# Player data
var items = {}
