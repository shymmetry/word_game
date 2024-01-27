extends Node

const board = [
	['/','/','/','*','/','/','/'],
	['/','/','*','*','*','/','/'],
	['/','*','*','*','*','*','/'],
	['*','*','*','*','*','*','*'],
	['/','*','*','*','*','*','/'],
	['/','/','*','*','*','/','/'],
	['/','/','/','*','/','/','/'],
]

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
