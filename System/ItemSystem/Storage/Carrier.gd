class_name Carrier
#外部组件
var item
var inventory_gui
var storage
#内部组件
var panel
var slot_set:Array

func _init(arg_storage_resource,arg_item):
	item = arg_item
	inventory_gui = Global.inventory_gui
	storage = Storage.new(arg_storage_resource)
	
func add_to_slot_new_heap(arg_item:ItemResource):
	storage.add_to_slot_new_heap(arg_item)
	
func add_to_slot_existing_heap(arg_item:ItemResource):
	storage.add_to_slot_existing_heap(arg_item)
	
func list_slot():
	return storage.list_slot()

