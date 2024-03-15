class_name  ItemHeap
#外部组件
var slot
#内部参数
var item_resource:ItemResource
var amount:int
var location:Vector2
#内部组件
var carrier

func _init(arg_item_resource:ItemResource,arg_amount:int):
	item_resource = arg_item_resource
	amount = arg_amount
	if item_resource.is_vessel():
		carrier = Carrier.new(ItemCenter.load_storage_resource(item_resource.storage_id),self)
		pass
		
		
func set_slot_position(arg_slot,arg_location:Vector2):
	slot = arg_slot
	location = arg_location
	


		
