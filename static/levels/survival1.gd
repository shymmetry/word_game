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
	"T": 1200,
	"A": 1000,
	"O": 1000,
	"I": 1000,
	"U": 1000,
	"S": 1200,
	"N": 800,
	"R": 800,
	"H": 700,
	"D": 500,
	"L": 500,
	"C": 300,
	"M": 300,
	"F": 300,
	"Y": 300,
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
