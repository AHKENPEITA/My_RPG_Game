class_name Storage
#外部组件
var inventory_gui
#内部组件
var panel
var slot_set:Array
#内部参数
var storage_resource


func _init(arg_storage_resource):
	storage_resource = arg_storage_resource
	for slot_id in storage_resource.slot_id_set:
		slot_set.append(Slot.new(ItemCenter.load_slot_class(slot_id)))

func add_to_slot_new_heap(arg_item:ItemResource):
	for slot in slot_set:
		if slot.add_to_new_heap(arg_item):
			return true
	return false
	
func add_to_slot_existing_heap(arg_item:ItemResource):
	for slot in slot_set:
		if slot.add_to_existing_heap(arg_item):
			return true
	return false
	
func list_slot():
	return slot_set

