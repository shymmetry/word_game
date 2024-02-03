extends CanvasLayer

var tutorial_steps = [
	{
		"text": "Find inspirational words to help you write your poem\nDrag in any direction to select a word",
		"node": "../Page/PlayArea/TileGrid",
		"bubble_pos": Vector2(140, 130)
	},{
		"text": "Each letter has the money it earns in the top left\nAt the end of the round letters will deal damage to you based on the number of guns on the bottom of the tile",
		"node": "../Page/PlayArea/TileGrid/TileArea/Tile",
		"bubble_pos": Vector2(115, 220)
	},{
		"text": "These are the words you have found\nThe round is over when you fill all prompts",
		"node": "../Page/HUD/HBoxContainer/VBoxContainer",
		"bubble_pos": Vector2(140, 270)
	},{
		"text": "This is your money\nMoney is earned when the poem is submitted\nMore money is awarded for longer words with more difficult to use letters",
		"node": "../Page/HUD/HBoxContainer/Trackers/GoldTracker",
		"bubble_pos": Vector2(100, 45)
	},{
		"text": "This is your life total\nDon't let it get to 0 or you lose",
		"node": "../Page/HUD/HBoxContainer/Trackers/LifeTracker",
		"bubble_pos": Vector2(100, 75)
	},{
		"text": "Press this powerup to get shown a word on the board",
		"node": "../Page/HUD/HBoxContainer/MarginContainer/Abilities/HintTracker",
		"bubble_pos": Vector2(180, 45)
	},{
		"text": "This powerup lets you swap two adjacent tiles by clicking them",
		"node": "../Page/HUD/HBoxContainer/MarginContainer/Abilities/SwapTracker",
		"bubble_pos": Vector2(180, 95)
	},{
		"text": "Lets you change any letter on the board to a Wild\nPress this button to activate",
		"node": "../Page/HUD/HBoxContainer/MarginContainer/Abilities/WildTracker",
		"bubble_pos": Vector2(180, 145)
	}
]
var current_step_i = 0

func _ready():
	Signals.connect("StartRound", _start_tutorial)
	Signals.connect("TutorialNext", _next)

func _next() -> void:
	current_step_i += 1
	if current_step_i == tutorial_steps.size():
		UserData.seen_tutorial = true
		UserData.save_data()
		self.hide()
	else:
		_show_current_step()

func _start_tutorial() -> void:
	if !UserData.seen_tutorial:
		_show_current_step()
		self.show()

func _show_current_step() -> void:
	var current_step = tutorial_steps[current_step_i]
	_create_shadow(get_node(current_step.node))
	_update_bubble(current_step.text, current_step.bubble_pos)

func _update_bubble(text: String, pos: Vector2) -> void:
	$HelpBubble.set_text(text)
	$HelpBubble.size = Vector2(0,0) # Ensures the bubble hugs the text
	$HelpBubble.position = pos

func _create_shadow(node: Node) -> void:
	var points = []
	points.append(Vector2(node.global_position.x, node.global_position.y))
	points.append(Vector2(node.global_position.x+node.size.x, node.global_position.y))
	points.append(Vector2(node.global_position.x+node.size.x, node.global_position.y+node.size.y))
	points.append(Vector2(node.global_position.x, node.global_position.y+node.size.y))
	$Polygon2D.polygon = PackedVector2Array(points)
