extends CanvasLayer

var tutorial_steps = [
	{
		"text": "Find inspirational words to help you write\nDrag in any direction to select a word",
		"node": "../Page/PlayArea/TileGrid",
		"bubble_pos": Vector2(140, 130)
	},{
		"text": "Each letter has the money it earns in the top left\nAt the end of the round letters will hurt you based on the number of stars on the bottom of the tile",
		"node": "../Page/PlayArea/TileGrid/TileArea/Tile",
		"bubble_pos": Vector2(115, 220)
	},{
		"text": "These are the words you have found\nThe round is over when you fill all prompts",
		"node": "../Page/HUD/HBoxContainer/VBoxContainer",
		"bubble_pos": Vector2(140, 270)
	},{
		"text": "This is your money\nMoney is earned when a round is over\nMore money is awarded for longer words",
		"node": "../Page/HUD/HBoxContainer/Trackers/GoldTracker",
		"bubble_pos": Vector2(100, 45)
	},{
		"text": "This is your life\nDon't let it get to 0 or you lose",
		"node": "../Page/HUD/HBoxContainer/Trackers/LifeTracker",
		"bubble_pos": Vector2(100, 75)
	},{
		"text": "You can view your purchased items here",
		"node": "../Page/Title/Buttons/Inventory",
		"bubble_pos": Vector2(200, 10)
	},{
		"text": "This is your energy bar\nUse your energy to perform actions that alter the board",
		"node": "../Page/HUD/HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/EnergyBar",
		"bubble_pos": Vector2(170, 95)
	},{
		"text": "This is an action\nIts energy cost is on the left\nThis action lets you swap two adjacent tiles by clicking them",
		"node": "../Page/HUD/HBoxContainer/MarginContainer/HBoxContainer/Abilities/SwapTracker",
		"bubble_pos": Vector2(180, 25)
	},{
		"text": "Press this action to get shown a word on the board\nAlways shows a 6 letter word if available",
		"node": "../Page/HUD/HBoxContainer/MarginContainer/HBoxContainer/Abilities/HintTracker",
		"bubble_pos": Vector2(180, 80)
	},{
		"text": "Lets you change any letter on the board to a Wild\nPress this action to activate",
		"node": "../Page/HUD/HBoxContainer/MarginContainer/HBoxContainer/Abilities/WildTracker",
		"bubble_pos": Vector2(180, 110)
	}
]
var current_step_i = 0

func _ready():
	Signals.connect("StartRound", _start_tutorial)
	Signals.connect("StartTutorial", _start_tutorial)
	Signals.connect("TutorialNext", _next)
	Signals.connect("TutorialSkipped", _done)

func _next() -> void:
	current_step_i += 1
	if current_step_i == tutorial_steps.size():
		_done()
	else:
		_show_current_step()

func _done() -> void:
	UserData.seen_tutorial = true
	UserData.save_data()
	self.hide()
	Globals.paused = false

func _start_tutorial() -> void:
	if !UserData.seen_tutorial:
		Globals.paused = true
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
