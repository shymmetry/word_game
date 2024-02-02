extends Node

var easy = Difficulty.new(
	"Easy",
	"Start with 100 life",
	100,
)

var medium = Difficulty.new(
	"Medium",
	"Start with 50 life",
	50,
)

var hard = Difficulty.new(
	"Hard",
	"Start with 25 life",
	25,
)

var difficulty_progression = [easy, medium, hard]
