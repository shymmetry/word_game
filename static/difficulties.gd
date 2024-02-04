extends Node

var easy = Difficulty.new(
	"Easy",
	"Start with 100 life and 10 energy",
	100,
	10,
)

var medium = Difficulty.new(
	"Medium",
	"Start with 50 life and 6 energy",
	50,
	6,
)

var hard = Difficulty.new(
	"Hard",
	"Start with 30 life and 3 energy",
	30,
	3,
)

var difficulty_progression = [easy, medium, hard]
