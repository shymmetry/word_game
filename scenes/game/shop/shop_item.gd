extends HBoxContainer

var item: Item = null

func set_item(_item: Item):
	item = _item
	$Item/Margin/HBox/VBox/Name.text = item.item_name
	$Item/Margin/HBox/VBox/Description.text = item.description
	$Item/Margin/HBox/Cost.text = "$%s" % item.cost

func _on_button_pressed():
	Signals.emit_signal("PurchaseItem", item)

func _process(_delta):
	if Globals.score < item.cost or (Globals.items[item] >= item.max_owned and item.max_owned != -1):
		$Buy.disabled = true
