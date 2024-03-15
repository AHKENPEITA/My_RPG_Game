class_name Entity extends Node2D
var location:Vector2
@export var occupied_coords:Array

func _init():
	pass

func _enter_tree():
	location = position_to_location(self.global_position)
	normalize_position()
	

func _ready():
	pass



func normalize_position():
	global_position = Vector2(location.x*16+8,location.y*16+8)
	
func position_to_location(arg_position)->Vector2:
	var x=(floorf(arg_position.x/16))
	var y=(floorf(arg_position.y/16))
	return Vector2(x,y)
	
func get_global_occupied_coords():
	var global_occupied_coords = []
	for coord in occupied_coords:
		location = position_to_location(self.global_position)
		
		var global_occupied_coord = Vector2(coord.x+location.x,coord.y+location.y)
		global_occupied_coords.append(global_occupied_coord)
	return global_occupied_coords
