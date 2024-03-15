extends Node2D
var tile_map:TileMap
var entity_container:Node2D
#本地方法
func _enter_tree():
	Global.world = self

func _ready():
	tile_map = $TileMap
	entity_container = $EntityContainer
func _exit_tree():
	pass
	
func get_default_character():
	return $Character
	

func get_PlayerCharacter()-> Node2D:
	return $Character
func get_TileMap()-> TileMap:
	return $TileMap
func find_Character(character_name:String)-> Node2D:
	return get_node(character_name)
