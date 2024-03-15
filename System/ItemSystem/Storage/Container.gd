extends Node
@export var storage_id:String
@export var container_name:String
var storage
func _ready():
	storage = Storage.new(ItemCenter.load_storage_resource(storage_id))
