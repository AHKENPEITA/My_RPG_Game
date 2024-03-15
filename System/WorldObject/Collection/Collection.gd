class_name Collection extends Node2D
@export var collectable:bool = false
@export var item:ItemResource

func unlock_collect():
	collectable = true

func lock_collect():
	collectable = false
