extends Node

var easy = Difficulty.new(
	"Easy",
	"3 Minutes per round",
	180,
)

var medium = Difficulty.new(
	"Medium",
	"2 Minutes per round",
	120,
)

var hard = Difficulty.new(
	"Hard",
	"1 Minutes per round",
	60,
)

var difficulty_progression = [easy, medium, hard]
