extends Node
class CarrierManager:
	
	class CarrierNode:#封装了carrier的链表单元，包含对prev\next的引用
		var carrier
		var prev
		var next
		func _init(arg_carrier):
			carrier = arg_carrier
		func set_next(arg_node):
			next = arg_node
		func set_prev(arg_node):
			prev = arg_node

	var flag_node = null
	
	func _init():
		pass
		
	func has_carrier()->bool:#判断容器管理器是否有至少一个容器
		return flag_node!=null
		
	func log_in_carrier(arg_carrier):#注册容器
		#为carrier新建node
		var new_node = CarrierNode.new(arg_carrier)
		#把node加入环
		if flag_node == null:#如果环是空的，要把前后都连接到自己
			flag_node = new_node
			flag_node.set_next(flag_node)
			flag_node.set_prev(flag_node)
		else:#如果环不是空的，用四步法插入节点
			flag_node.next.set_prev(new_node)
			flag_node.next.prev.set_prev(flag_node)
			flag_node.next.prev.set_next(flag_node.next)
			flag_node.set_next(flag_node.next.prev)
			flag_node = flag_node.next
			
		for slot in arg_carrier.slot_set:
			slot.storage = self
			
		EventCenter.BroadCast0(EventCenter.COM_RefreshCarrier)
		
	func log_out_carrier(arg_carrier):#注销容器
		#在集合中以carrier为标志，查询待踢出节点
		var outing_node
		for node in list_node():
			if arg_carrier == node.carrier:
				outing_node = node
				break
		#将待踢出节点从环里踢出
		if flag_node.next != flag_node:#多余一个节点在环里等待被踢出的情况
			if outing_node == flag_node:#待踢出节点是指针节点，需要把指针挪开再用二步法踢出节点，若不是指针节点，则直接二步踢出
				flag_node = outing_node.prev
			#二步法踢出节点
			outing_node.prev.set_next(outing_node.next)
			outing_node.next.set_prev(outing_node.prev)
			
		else:#只剩一个节点在环里等待被踢出的情况，直接把前后设空，最后把自己设空
			flag_node.next = null
			flag_node.prev = null
			flag_node = null
			
		EventCenter.BroadCast0(EventCenter.COM_RefreshCarrier)

	func stepping_cycle(arg_sign):#步进遍历环，改变指针指向的容器，sign标志着每一步遍历的方向
		if flag_node!=null:#防止没有指针节点时查询前后节点为空的问题
			if arg_sign == 1:
				flag_node = flag_node.next
			elif arg_sign ==-1:
				flag_node = flag_node.prev
	
	func get_flag_carrier():#获取指针指向的容器
		return flag_node.carrier
	
	func list_node():#从指针节点开始，列出所有节点
		if has_carrier():#容器节点环里有节点时，返回以flag_node为起点的node列表
			var node_list = [flag_node]
			var list_flag_node = flag_node
			while list_flag_node.next != flag_node:
				list_flag_node = list_flag_node.next
				node_list.append(list_flag_node)
			return node_list
		else:#环里无节点时，返回空集
			return []
	
	func list_carrier():#从指针节点容器开始，列出所有容器
		var node_list = list_node()
		if node_list != []:
			var carrier_list = []
			for node in node_list:
				carrier_list.append(node.carrier)
			return carrier_list
		else:
			return []
			
		
	#debug cod
	func debug_list_carrier_ring():
		var broadcast_slot = flag_node
		var debugstr = "["+broadcast_slot.carrier.item.item_resource.name+"]"
		while broadcast_slot.next.carrier!=flag_node.carrier:
			broadcast_slot = broadcast_slot.next
			debugstr = debugstr+"   "+broadcast_slot.carrier.item.item_resource.name
		print(debugstr)	
	func debug_carrier_ring_not_empty():
		prints("carrier_ring_not_empty is: ",flag_node!=null)
		
var carrier_manager
var tool_main1#双手武器
var tool_main2
var tool_vice1#单手武器
var tool_vice2
var hat#帽子、头饰、发卡、头花、耳环
var coat#大衣、长袍、胸甲
var trousers#裤子、腿铠
var boot#鞋子、靴子、战靴
var back#背包、职业背包、盾、箭袋
var haversack#挎包、提篮、匕首鞘
var headwear#手镯、手表、护腕、指环
var pandant#手镯、手表、护腕、指环
var belt#腰带、邦典、挂灯、玉佩、香囊
var bracelet#手镯、手表、护腕、指环
var belongings#持有物品，容器无法在这个栏里解包
#var carrier_set:Array #当有装备进入装备栏时，会检测其是否是容器，如果是话，将其置入该数组，以期容器监视方法的调用，同时，当装备离开装备栏时，将其踢出该数组
var pointing_carrier#当前指向的carrier
var carrier_panel:Panel

signal storage_overflow

func _ready():
	carrier_manager = CarrierManager.new()
	
	tool_main1 = Slot.new(ItemCenter.load_slot_class("SlotToolMain"))
	tool_main2 = Slot.new(ItemCenter.load_slot_class("SlotToolMain"))
	tool_vice1 = Slot.new(ItemCenter.load_slot_class("SlotToolVice"))
	tool_vice2 = Slot.new(ItemCenter.load_slot_class("SlotToolVice"))
	
	hat = Slot.new(ItemCenter.load_slot_class("SlotHat"))
	coat = Slot.new(ItemCenter.load_slot_class("SlotCoat"))
	trousers = Slot.new(ItemCenter.load_slot_class("SlotTrousers"))
	boot = Slot.new(ItemCenter.load_slot_class("SlotBoot"))
	back = Slot.new(ItemCenter.load_slot_class("SlotBack"))
	haversack = Slot.new(ItemCenter.load_slot_class("SlotHaversack"))
	headwear = Slot.new(ItemCenter.load_slot_class("SlotHeadwear"))
	pandant = Slot.new(ItemCenter.load_slot_class("SlotPandant"))
	belt = Slot.new(ItemCenter.load_slot_class("SlotBelt"))
	bracelet = Slot.new(ItemCenter.load_slot_class("SlotBracelet"))
	belongings = Slot.new(ItemCenter.load_slot_class("SlotBelongings"))
	
	tool_main1.set_storage(self)
	tool_main2.set_storage(self)
	tool_vice1.set_storage(self)
	tool_vice2.set_storage(self)
	hat.set_storage(self)
	coat.set_storage(self)
	trousers.set_storage(self)
	boot.set_storage(self)
	back.set_storage(self)
	haversack.set_storage(self)
	headwear.set_storage(self)
	pandant.set_storage(self)
	belt.set_storage(self)
	bracelet.set_storage(self)
	belongings.set_storage(self)
	
func Add(arg_item:ItemResource)->bool:
	#首先尝试往优先分类槽位放置（工具、武器、护甲、配饰）
	#工具和武器槽
	if arg_item.is_tool():
		if tool_main1.Add(arg_item):
			return true
		if tool_main2.Add(arg_item):
			return true
		if tool_vice1.Add(arg_item):
			return true
		if tool_vice2.Add(arg_item):
			return true
	#护甲和配饰槽
	if arg_item.has_tag("Hat"):
		if hat.Add(arg_item):
			return true
	if arg_item.has_tag("Coat"):
		if coat.Add(arg_item):
			return true
	if arg_item.has_tag("Trousers"):
		if trousers.Add(arg_item):
			return true
	if arg_item.has_tag("Boot"):
		if boot.Add(arg_item):
			return true
	if arg_item.has_tag("Back"):
		if back.Add(arg_item):
			return true
	if arg_item.has_tag("Haversack"):
		if haversack.Add(arg_item):
			return true
	if arg_item.has_tag("Headwear"):
		if headwear.Add(arg_item):
			return true
	if arg_item.has_tag("Pandant"):
		if pandant.Add(arg_item):
			return true
	if arg_item.has_tag("Belt"):
		if belt.Add(arg_item):
			return true
	if arg_item.has_tag("Bracelet"):
		if bracelet.Add(arg_item):
			return true
	
	#如果并非优先归类种类的，继续进行分类
	#优先查找已存在相同物品而数量不满的堆进行放置
	if carrier_manager.has_carrier():#先找容器
		var carrier_list = carrier_manager.list_carrier()
		for carrier in carrier_list:
			for slot in carrier.list_slot():
				if slot.add_to_existing_heap(arg_item):
					return true
	if belongings!=null:#再找物品栏
		if belongings.add_to_existing_heap(arg_item):
			return true
	
	#如果已存在相同物品而数量不满的，新建物品堆进行放置
	if carrier_manager.has_carrier():#先找容器
		var carrier_list = carrier_manager.list_carrier()
		for carrier in carrier_list:
			for slot in carrier.list_slot():
				if slot.add_to_new_heap(arg_item):
					return true
	if belongings!=null:#再找物品栏
		if belongings.add_to_new_heap(arg_item):
			return true
	emit_signal("storage_overflow")
	print("向角色库存添加物品失败")
	return false
	
	
func AddMultiple(arg_item:ItemResource,arg_amount:int):
	for index in arg_amount:
		Add(arg_item)
	
	EventCenter.BroadCast0(EventCenter.COM_RefreshCarrier)
		
	
