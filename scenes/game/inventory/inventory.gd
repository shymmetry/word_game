extends Panel

const inventory_item = preload("res://scenes/game/inventory/inventory_item.tscn")

func _ready():
	Signals.connect("ItemPurchaseComplete", _update_inventory)

func _update_inventory():
	_reset_inventory()
	for item in Globals.items:
		var quantity = Globals.items[item]
		
		var inv_item = inventory_item.instantiate()
		inv_item.setup(item, quantity)
		$Margin/Contents/Items.add_child(inv_item)

func _reset_inventory():
	for n in $Margin/Contents/Items.get_children():
		$Margin/Contents/Items.remove_child(n)
		n.queue_free()

func _on_back_pressed():
	Globals.paused = false
	self.hide()
