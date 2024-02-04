extends HBoxContainer

func setup(item: Item, quantity: int) -> void:
	$Item/Margin/HBox/VBox/Name.text = item.item_name
	$Item/Margin/HBox/VBox/Description.text = item.description
	$Item/Margin/HBox/Quantity.text = "x%d" % quantity
