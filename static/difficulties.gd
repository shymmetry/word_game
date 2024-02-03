extends Node

var easy = Difficulty.new(
	"Easy",
	"Start with 100 life",
	100,
	10,
)

var medium = Difficulty.new(
	"Medium",
	"Start with 50 life",
	50,
	6,
)

var hard = Difficulty.new(
	"Hard",
	"Start with 25 life",
	25,
	2,
)

var difficulty_progression = [easy, medium, hard]
