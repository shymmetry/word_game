extends Node

const min_word_length = 4
const word_cnt_goal = 8
const win_type = E.WIN_TYPE.CONTAINS_SPECIAL

const tile_type_chance = {
	E.TILE_TYPE.NORMAL: 78,
	E.TILE_TYPE.SPECIAL: 20,
	E.TILE_TYPE.MULTIPLIER: 2,
}

const board = Boards.microchip
