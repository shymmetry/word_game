extends Panel

func _process(_delta):
	if Globals.swaps >= 1: $Box/Margin/Ticks/PowerTick.on()
	else: $Box/Margin/Ticks/PowerTick.off()
	if Globals.swaps >= 2: $Box/Margin/Ticks/PowerTick2.on()
	else: $Box/Margin/Ticks/PowerTick2.off()
	if Globals.swaps >= 3: $Box/Margin/Ticks/PowerTick3.on()
	else: $Box/Margin/Ticks/PowerTick3.off()
	if Globals.swaps >= 4: $Box/Margin/Ticks/PowerTick4.on()
	else: $Box/Margin/Ticks/PowerTick4.off()
	if Globals.swaps >= 5: $Box/Margin/Ticks/PowerTick5.on()
	else: $Box/Margin/Ticks/PowerTick5.off()
