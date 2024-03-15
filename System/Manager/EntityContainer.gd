extends Node
var entity_table:DataStructure.MapTable
var interactor_table:Dictionary
var occupied
var growable_coords = []

func _enter_tree():
	Global.entity_container = self
	entity_table = DataStructure.MapTable.new()
	catch_all_entity()
	#sign_entity()
	#print(1)
	#print(get_children())

func sign_entity(arg_entity):
	var global_occupied_coords = arg_entity.get_global_occupied_coords()
	for coord in global_occupied_coords:
		if entity_table.check_coord(coord):
			return false
	for coord in global_occupied_coords:
		entity_table.add_to_coord(coord,arg_entity)
	return true
		
func catch_all_entity():
	for child in get_children():
		if !sign_entity(child):
			child.free()
	
func add_entity(arg_entity:Entity)->bool:
	if sign_entity(arg_entity):
		add_child(arg_entity)
		return true
	else:
		arg_entity.free()
		return false
	
	
	#entity_table[arg_entity.location]=arg_entity
	
func add_interactor(arg_interactor):
	interactor_table[arg_interactor.location]=arg_interactor
	
func get_interactor(arg_location):
	if interactor_table.has(arg_location):
		return interactor_table[arg_location]
	else:
		return null
	
func set_growable(arg_coords):
	growable_coords = arg_coords
	for coord in growable_coords:
		#print(coord)
		random_set_plant(coord)
	

func random_set_plant(arg_coord):
	if randf()<=0.2:
		var plant = preload(LoadPathCenter.test_plant_path).instantiate()
		plant.global_position = Vector2(coord_to_position(arg_coord))
		add_entity(plant)
		#print(2)

func coord_to_position(arg_coord:Vector2):
	var x = arg_coord.x*16+8
	var y = arg_coord.y*16+8
	return Vector2(x,y)
