extends Panel

const inventory_item = preload("res://scenes/game/inventory/inventory_item.tscn")

func _ready():
	_update_inventory()
	Signals.connect("ItemPurchaseComplete", _update_inventory)

func _update_inventory():
	_reset_inventory()
	for item in Globals.items:
		var quantity = Globals.items[item]
		
		var inv_item = inventory_item.instantiate()
		inv_item.setup(item, quantity)
		$Contents/Margin/Items.add_child(inv_item)

func _reset_inventory():
	for n in $Contents/Margin/Items.get_children():
		$Contents/Margin/Items.remove_child(n)
		n.queue_free()

func _on_back_pressed():
	Globals.paused = false
	self.hide()
