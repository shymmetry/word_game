extends HBoxContainer

var disabled_style = preload("res://styles/items/shop_item_disabled.tres")

var item: Item

func set_item(_item: Item):
	item = _item
	$Item/Margin/HBox/VBox/Name.text = item.item_name
	$Item/Margin/HBox/VBox/Description.text = item.description
	$Item/Margin/HBox/Cost.text = "$%s" % ItemUtil.get_item_price(item.cost)

func disable():
	$Buy.disabled = true
	$Item.add_theme_stylebox_override("panel", disabled_style)

func _on_button_pressed():
	Signals.emit_signal("PurchaseItem", item)

func _process(_delta):
	if Globals.score < item.cost:
		$Buy.disabled = true
	
	if item:
		$Item/Margin/HBox/Cost.text = "$%s" % ItemUtil.get_item_price(item.cost)
