extends Node

var attack = GameType.new(
	"Attack",
	"Starting tiles deal damage if alive at round end\nUntimed",
	E.GAME_TYPE.ATTACK,
)

var timed = GameType.new(
	"Timed",
	"Timed levels",
	E.GAME_TYPE.TIMED,
)

var game_type_progression = [attack, timed]
