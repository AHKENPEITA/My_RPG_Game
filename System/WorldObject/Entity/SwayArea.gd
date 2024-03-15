extends Area2D
signal sway_direction
#var locked:bool = false

func _on_body_entered(body):
	if body.global_position.x-self.global_position.x<0:
		emit_signal("sway_direction",Vector2.RIGHT)
	elif body.global_position.x-self.global_position.x>0:
		emit_signal("sway_direction",Vector2.LEFT)

#func lock():
	#locked = true
#
#func unlock():
	#locked = false
