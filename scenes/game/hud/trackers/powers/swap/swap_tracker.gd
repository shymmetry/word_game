extends Panel

func _ready():
	$Margin/Box/Cost.text = str(PowerUtil.energy_cost(Powers.swap))
