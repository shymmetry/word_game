extends Node

var bullet_scene = preload("res://scenes/game/damage/bullet.tscn")

func take_damage(life_tracker_pos: Vector2):
	for tile_row in Globals.tiles:
		for tile in tile_row:
			if tile.damage > 0:
				var bullet = bullet_scene.instantiate()
				bullet.position = tile.global_position + tile.size / 2
				$CanvasLayer.add_child(bullet)
				
				var tween = create_tween()
				tween.tween_property(bullet, "position", life_tracker_pos, 0.2)
				tween.tween_callback(func():
					Globals.life -= tile.damage
					bullet.queue_free()
				)
				await tween.finished
