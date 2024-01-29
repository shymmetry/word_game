extends VBoxContainer

var item_scene = preload("res://scenes/game/shop/shop_item.tscn")

var items = []

func _ready():
	Signals.connect("PurchaseItem", _purchase_item)
	Signals.connect("ShowShop", _init_shop)

func _init_shop():
	_clear_shop()
	items = ItemUtil.get_random_items(4, false)
	for item in items:
		var new_item = item_scene.instantiate()
		new_item.set_item(item)
		
		add_child(new_item)

func _clear_shop():
	for n in self.get_children():
		remove_child(n)
		n.queue_free()

func _purchase_item(purchase_item: Item):
	if Globals.score >= purchase_item.cost:
		for child in self.get_children():
			if child.item == purchase_item:
				Globals.score -= purchase_item.cost
				purchase_item.effect.call()
				#Sounds.cha_ching()
				
				if Globals.items.has(purchase_item):
					Globals.items[purchase_item] = Globals.items.get(purchase_item) + 1
				else:
					Globals.items[purchase_item] = 1
				
				self.remove_child(child)
				child.queue_free()
				break
