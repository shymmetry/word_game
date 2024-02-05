extends Control

func _process(_delta):
	if Globals.shop_refresh_cost > Globals.score:
		$MainCol/HBoxContainer/Refresh.disabled = true
	else:
		$MainCol/HBoxContainer/Refresh.disabled = false
	$MainCol/HBoxContainer/Refresh.text = "Refresh ($%d)" % Globals.shop_refresh_cost

func _on_next_round_pressed():
	Signals.emit_signal("NextRound")

func _on_refresh_pressed():
	Signals.emit_signal("RefreshShop")
