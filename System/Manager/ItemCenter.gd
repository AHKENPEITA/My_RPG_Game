extends Node
var ItemResourceDictionary = {}
var StorageResourceDictionary = {}
var SlotResourceDictionary = {}
var item_resource_path = LoadPathCenter.item_resource_path
var storage_resource_path = LoadPathCenter.storage_resource_path
var slot_resource_path = LoadPathCenter.slot_resource_path
var rect_path = LoadPathCenter.rect_path


func _ready():
	#加载tem资源
	var item_resource_array = DirAccess.get_files_at(item_resource_path)
	for item_resource in item_resource_array:
		var loading_item_resource:ItemResource = load("{item_resource_path}{item_resource}".format({"item_resource_path":item_resource_path,"item_resource":item_resource}))
		ItemResourceDictionary[loading_item_resource.id] = loading_item_resource
	#加载storage资源
	var storage_resource_array = DirAccess.get_files_at(storage_resource_path)
	for storage_resource in storage_resource_array:
		var loading_storage_resource:StorageResource = load("{storage_resource_path}{storage_resource}".format({"storage_resource_path":storage_resource_path,"storage_resource":storage_resource}))
		StorageResourceDictionary[loading_storage_resource.storage_id] = loading_storage_resource
	#加载slot资源
	var slot_resource_array = DirAccess.get_files_at(slot_resource_path)
	for slot_resource in slot_resource_array:
		var loading_slot_resource:SlotResource = load("{slot_resource_path}{slot_resource}".format({"slot_resource_path":slot_resource_path,"slot_resource":slot_resource}))
		SlotResourceDictionary[loading_slot_resource.slot_id] = loading_slot_resource
		
func find_item_resource(arg_id:String)->ItemResource:
	if !ItemResourceDictionary.has(arg_id):
		push_error("查询物品信息错误：物品字典未包含id为",arg_id,"的物品的定义")
		return null
	else:
		return ItemResourceDictionary[arg_id]

func load_storage_resource(arg_id:String)->StorageResource:
	if !StorageResourceDictionary.has(arg_id):
		push_error("查询容器信息错误：容器字典未包含id为",arg_id,"的容器的定义")
		return null
	else:
		return StorageResourceDictionary[arg_id]
	
func load_slot_class(arg_id:String)->SlotResource:
	if !SlotResourceDictionary.has(arg_id):
		push_error("查询物品槽位信息错误：槽位字典未包含id为",arg_id,"的槽位的定义")
		return null
	else:
		return SlotResourceDictionary[arg_id]
		
func load_item_rect(arg_item,arg_panel):
	var item_rect = load(rect_path).instantiate()
	item_rect.set_rect(arg_item,arg_panel)
	return item_rect
	
func name_of(arg_id:String)->String:
	if find_item_resource(arg_id)!=null:
		return find_item_resource(arg_id).name
	else:
		push_error("查询物品名字错误：物品中心未包含id为",arg_id,"的物品的定义")
		return ""
	
func size_of(arg_id:String)->Vector2:
	if find_item_resource(arg_id)!=null:
		return find_item_resource(arg_id).size
	else:
		push_error("查询物品尺寸错误：物品中心未包含id为",arg_id,"的物品的定义")
		return Vector2.ZERO
		
func limit_of(arg_id:String)->int:
	if find_item_resource(arg_id)!=null:
		return find_item_resource(arg_id).stack_limit
	else:
		push_error("查询物品堆叠数量错误：物品中心未包含id为",arg_id,"的物品的定义")
		return 0
		
func texture_of(arg_id:String)->Texture:
	if find_item_resource(arg_id)!=null:
		return find_item_resource(arg_id).texture
	else:
		push_error("查询物品贴图错误：物品中心未包含id为",arg_id,"的物品的定义")
		return null


