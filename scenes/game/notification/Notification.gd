extends Panel

var notification_message = preload("res://scenes/game/notification/notification_message.tscn")
var current_message = null

func _ready():
	Signals.connect("NotifyPlayer", _update_text)

func _update_text(new_text: String):
	if current_message:
		current_message.queue_free()
	
	var new_message = notification_message.instantiate()
	new_message.set_message(new_text)
	add_child(new_message)
	current_message = new_message
