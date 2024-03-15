extends Node2D

func sway_fruit(arg_direction:Vector2):
	for fruit_node in get_children():
		fruit_node.sway_fruit(arg_direction)

func release_fruit(arg_direction:Vector2):
	for fruit_node in get_children():
		fruit_node.release_fruit(arg_direction)
