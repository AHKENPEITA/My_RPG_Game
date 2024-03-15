extends Node2D
@export var fruit_animation:AnimationPlayer

func sway_fruit(arg_direction:Vector2):
	fruit_animation.stop()
	match arg_direction:
		Vector2.RIGHT:
			fruit_animation.play("sway_right")
		Vector2.LEFT:
			fruit_animation.play("sway_left")

func release_fruit(arg_direction:Vector2):
	fruit_animation.stop()
	match arg_direction:
		Vector2.RIGHT:
			print("release_right")
		Vector2.LEFT:
			print("release_left")

func has_fruir()->bool:
	return find_child("Fruit")!=null
