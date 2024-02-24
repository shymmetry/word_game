extends VBoxContainer

var item_scene = preload("res://scenes/game/shop/shop_item.tscn")

var items = []
const DISPLAYED_ITEMS = 5

func _ready():
	Signals.connect("PurchaseItem", _purchase_item)
	Signals.connect("ShowShop", _init_shop)
	Signals.connect("RefreshShop", _refresh_shop)

func _sort_items(a: Item, b: Item):
	if typeof(a) == typeof(b):
		return a.base_cost < b.base_cost
	return false

func _init_shop():
	_clear_shop()
	items = ItemUtil.get_random_items(DISPLAYED_ITEMS, false)
	items.sort_custom(_sort_items)
	for item in items:
		var new_item = item_scene.instantiate()
		new_item.set_item(item)
		
		add_child(new_item)

func _clear_shop():
	for n in self.get_children():
		remove_child(n)
		n.queue_free()

func _refresh_shop():
	if Globals.score >= Globals.shop_refresh_cost:
		Globals.score -= Globals.shop_refresh_cost
		Globals.shop_refresh_cost += 1
		_clear_shop()
		_init_shop()
	else:
		Sounds.error()

func _purchase_item(purchase_item: Item):
	if Globals.score >= ItemUtil.get_item_price(purchase_item.base_cost):
		for child in self.get_children():
			if child.item == purchase_item:
				Globals.score -= ItemUtil.get_item_price(purchase_item.base_cost)
				if purchase_item.effect:
					purchase_item.effect.call()
				#Sounds.cha_ching()
				
				# Add item to inventory
				if Globals.items.has(purchase_item):
					Globals.items[purchase_item] = Globals.items.get(purchase_item) + 1
				else:
					Globals.items[purchase_item] = 1
				
				child.disable()
				
				Signals.emit_signal("ItemPurchaseComplete")
				break
