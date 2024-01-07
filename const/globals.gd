extends Node

const rows = 6
const cols = 6
const tile_size = 60
const padding = 10
const min_word_length = 4

var idle = false

var tiles = []
var score = 0
var swaps = 1

# Player variables
var high_score = 0
var completed_levels = []
