extends Node

const time_seconds = 90
const swaps = 1
const hints = 0
const life = 100

const dmg_probs = {
	0: 20,
	1: 80,
	2: 0,
	3: 0,
	4: 0,
	5: 0,
}

const letter_freq = {
	"?": 300,
	"E": 1000,
	"T": 1000,
	"A": 1000,
	"O": 1000,
	"I": 1000,
	"U": 1000,
	"S": 1000,
	"N": 700,
	"R": 700,
	"H": 600,
	"D": 400,
	"L": 400,
	"C": 200,
	"M": 200,
	"F": 200,
	"Y": 200,
	"W": 0,
	"G": 0,
	"P": 0,
	"B": 0,
	"V": 0,
	"K": 0,
	"X": 0,
	"Q": 0,
	"J": 0,
	"Z": 0
}
