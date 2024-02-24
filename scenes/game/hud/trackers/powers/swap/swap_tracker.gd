extends Panel

func _ready():
	$Margin/Box/Cost.text = str(Powers.swap.energy_cost)
