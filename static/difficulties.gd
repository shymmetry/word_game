extends Node

var easy = Difficulty.new(
	"Easy",
	"Start with 100% life and 100% energy",
	100,
	100,
)

var medium = Difficulty.new(
	"Medium",
	"Start with 75% life and 75% energy",
	75,
	75,
)

var hard = Difficulty.new(
	"Hard",
	"Start with 50% life and 50% energy",
	50,
	50,
)

var difficulty_progression = [easy, medium, hard]
