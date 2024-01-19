extends Node

# Constants
const all_letters = "ETAOINSRUDLHCMFYWGPBVKXQJZ" # ordered by frequency for speed

# Game variables
var game_mode = null
var rows = 6
var cols = 6
var tiles = [] # 2D array of all tiles in play
var score = 0
var swaps = 1
var hints = 1
var elapsed_seconds = 0
var matched_words = []

var gold = 0
var life = 0

# Game state
var board_changed = false #ONLY FOR BASE GAME SCRIPT HANDLING
var idle = true

# Tile state
var selected_tile = null
var dragged_tiles: Array[Tile] = []
var hint_tiles = []

# Level info
var current_level = 0
var level_data = null
