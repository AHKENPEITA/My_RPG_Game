class_name Slot
var storage:Node
#本地组件
var item_set:Array
var item_table:Dictionary
#本地参数
var slot_resource

var grid_size:Vector2
var is_carrier_port:bool
var black_list:Dictionary
var white_list:Dictionary

enum{
	Case_ExcessOfStroke,
	Case_TypeNotMatch,
	Case_Conflict,
	Case_LayDirect
}

#初始化、物理帧、动画帧、终止
func _init(arg_slot_resource):
	slot_resource = arg_slot_resource
	grid_size = slot_resource.grid_size
	is_carrier_port = slot_resource.is_carrier_port
	black_list = slot_resource.black_list
	white_list = slot_resource.white_list
	
	for row in slot_resource.grid_size.y:
		for column in slot_resource.grid_size.x:
			item_table[Vector2(column,row)] = null
	pass
	
#本地方法
func set_storage(arg_storage):
	storage = arg_storage
	
func exclusive_conflict()->bool:#检查当前槽位是否有专用冲突
	if item_set.size()==0||!slot_resource.is_exclusive:
		return false
	else:
		return true
		
func add_to_existing_heap(arg_item_resource:ItemResource)->bool:#向已存在相同物品而数量不满的堆进行放置
	for index in item_set.size():
		if item_set[index].item_resource==arg_item_resource:
			if item_set[index].amount < item_set[index].item_resource.stack_limit:
				item_set[index].amount += 1
				EventCenter.BroadCast0(EventCenter.COM_RefreshDisplay)
				return true
	return false
		
func add_to_new_heap(arg_item_resource:ItemResource)->bool:
	var space_position = find_lay_position(arg_item_resource.size)
	if space_position == null:#当查找不到可以摆下该物品的空间时，结束循环，返回剩余待加数量
		return false
	else:#找到空间的话就新建物品栈加入库存
		var column = space_position.x
		var row = space_position.y
		var new_item_heap = ItemHeap.new(arg_item_resource,1)
		new_item_heap.set_slot_position(self,Vector2(column,row))
		
		if new_item_heap.carrier!=null && slot_resource.is_carrier_port:#为带有容器的装备注册容器
			storage.carrier_manager.log_in_carrier(new_item_heap.carrier)
			#new_item_heap.carrier.log_in(storage)
		
		item_set.append(new_item_heap)
		#设置占用位置
		for sub_row in arg_item_resource.size.y:
			for sub_column in arg_item_resource.size.x:
				item_table[Vector2(column+sub_column,row+sub_row)] = new_item_heap
		EventCenter.BroadCast0(EventCenter.COM_RefreshDisplay)
		return true
		
		
func Add(arg_item_resource:ItemResource)->bool:#通用单个物品添加方法，涵盖专用槽、现存堆、新堆等细分状况
	if exclusive_conflict():#排除专用槽冲突情况
		return false
	elif add_to_existing_heap(arg_item_resource):#找已经存在于列表中的物品，通过数量自增的方式加
		return true
	elif add_to_new_heap(arg_item_resource):#若该途径没有把全部物品加完，则寻找空位新建物品堆
		return true
	else:
		return false

func AddMultiple(arg_item_resource:ItemResource,arg_amount:int)->int:#返回一个剩余未归置数量
	#这是一个不严格的添加方法，如果在装载过程中背包已满但是还有物品没装进去的话，会返回剩余的物品的数量，若全都装进去的话，返回0
	#与之对应的有一个严格添加的方法，如果经计算无法完美添加的话，将返回false,并将背包状态更改到添加物品之前的状态
	var amount_remaining = arg_amount
	#先找已经存在于列表中的物品，通过数量自增的方式加
	for index in item_set.size():
		if item_set[index].item_resource==arg_item_resource && item_set[index].amount<item_set[index].item_resource.stack_limit:
			if item_set[index].amount+amount_remaining <= item_set[index].item_resource.stack_limit:
				item_set[index].amount += amount_remaining
				EventCenter.BroadCast0(EventCenter.COM_RefreshDisplay)
				return 0
			else:
				item_set[index].amount = item_set[index].item_resource.stack_limit
				amount_remaining -= item_set[index].item_resource.stack_limit-item_set[index].amount
	#若该途径没有把全部物品加完，则寻找空位新建物品堆
	
	while amount_remaining>0:#当剩余待加数量不为零时，重复查找步骤
		
		var space_position = find_lay_position(arg_item_resource.size)
		if space_position == null:#当查找不到可以摆下该物品的空间时，结束循环，返回剩余待加数量
#			print(str(amount_remaining)+"个物品过大无法添加")
			return amount_remaining
		else:#找到空间的话就新建物品栈加入库存
			var column = space_position.x
			var row = space_position.y
			if amount_remaining<=arg_item_resource.stack_limit:#当剩余物品数量小于或等于堆叠上限时，用正常方式新建物品栈并加入库存，返回剩余量0
				var new_item_heap = ItemHeap.new(arg_item_resource,amount_remaining)
				new_item_heap.set_slot_position(self,Vector2(column,row))
				item_set.append(new_item_heap)
				#设置占用位置
				for sub_row in arg_item_resource.size.y:
					for sub_column in arg_item_resource.size.x:
						item_table[Vector2(column+sub_column,row+sub_row)] = new_item_heap
#				EventCenter.BroadCast0(EventCenter.COM_RefreshDisplay)
				return 0
			else:#新建的栈只会保有堆叠上限数量个物品，并更新剩余物品数量，以备下一轮循环使用
				var new_item_heap = ItemHeap.new(arg_item_resource,arg_item_resource.stack_limit)
				new_item_heap.set_slot_position(self,Vector2(column,row))
				item_set.append(new_item_heap)
				#设置占用位置
				for sub_row in arg_item_resource.size.y:
					for sub_column in arg_item_resource.size.x:
						item_table[Vector2(column+sub_column,row+sub_row)] = new_item_heap
				amount_remaining -= arg_item_resource.stack_limit
#	EventCenter.BroadCast0(EventCenter.COM_RefreshDisplay)
	
	return amount_remaining

func merge_with (arg_mouse_rect,arg_item):
	if arg_mouse_rect.amount+arg_item.amount<=arg_item.item_resource.stack_limit:
		arg_item.amount = arg_mouse_rect.amount+arg_item.amount
		return 0
	else:
		var amount_remaining = arg_mouse_rect.amount+arg_item.amount-arg_item.item_resource.stack_limit
		arg_item.amount = arg_item.item_resource.stack_limit
		return amount_remaining

func clear_item(arg_item):
	for sub_row in arg_item.item_resource.size.y:
		for sub_column in arg_item.item_resource.size.x:
			item_table[Vector2(arg_item.location.x+sub_column,arg_item.location.y+sub_row)]=null
	item_set.erase(arg_item)
	pass

func find_lay_position(arg_size:Vector2):
	for row in slot_resource.grid_size.y:
		if row+arg_size.y > slot_resource.grid_size.y:
			return null
		for column in slot_resource.grid_size.x:
			if column+arg_size.x > slot_resource.grid_size.x:
				break
			var occupied:bool = false
			for sub_row in arg_size.y:
				for sub_column in arg_size.x:
					if item_table[Vector2(column+sub_column,row+sub_row)]!=null:
						occupied = true
						break
				if occupied:
					break
			if !occupied:
				return Vector2(column,row)
	return null

func pick_item_up(arg_item):
	if item_set.has(arg_item):
		item_set.erase(arg_item)
		for sub_row in arg_item.item_resource.size.y:
			for sub_column in arg_item.item_resource.size.x:
				item_table[Vector2(arg_item.location.x+sub_column,arg_item.location.y+sub_row)] = null
	if arg_item.carrier!=null && slot_resource.is_carrier_port:
		storage.carrier_manager.log_out_carrier(arg_item.carrier)
		#arg_item.carrier.log_out(storage)
	
func pick_item_once(arg_item):
	if arg_item.amount>1:
		arg_item.amount -= 1
	else:
		clear_item(arg_item)
		return true#true表示取完了

func exchange_item(arg_pick_item,arg_lay_item,arg_grid):
	###先把目标空间内的占用item清除
	if item_set.has(arg_pick_item):
		item_set.erase(arg_pick_item)
		for sub_row in arg_pick_item.item_resource.size.y:
			for sub_column in arg_pick_item.item_resource.size.x:
				item_table[Vector2(arg_pick_item.location.x+sub_column,arg_pick_item.location.y+sub_row)] = null
	else:
		print("错误：找不到arg_item")
	###然后把新增的item填充到网格中
	arg_lay_item.set_slot_position(self,Vector2(arg_grid.x,arg_grid.y))
	item_set.append(arg_lay_item)
	for sub_row in arg_lay_item.item_resource.size.y:
		for sub_column in arg_lay_item.item_resource.size.x:
			item_table[Vector2(arg_grid.x+sub_column,arg_grid.y+sub_row)] = arg_lay_item

func set_item_to(arg_item,arg_grid_position):
	arg_item.set_slot_position(self,Vector2(arg_grid_position.x,arg_grid_position.y))
	item_set.append(arg_item)
	for sub_row in arg_item.item_resource.size.y:
		for sub_column in arg_item.item_resource.size.x:
			item_table[Vector2(arg_grid_position.x+sub_column,arg_grid_position.y+sub_row)] = arg_item
	if arg_item.carrier!=null && slot_resource.is_carrier_port:
		storage.carrier_manager.log_in_carrier(arg_item.carrier)
		#arg_item.carrier.log_in(storage)
		
func check_lay_space(arg_item_resource,arg_grid):
	if !check_type(arg_item_resource):
		return Case_TypeNotMatch
	if arg_grid.y+arg_item_resource.size.y > slot_resource.grid_size.y || arg_grid.x+arg_item_resource.size.x > slot_resource.grid_size.x:
		return Case_ExcessOfStroke#区间超程，无法操作，返回false
	else:
		var occupied_item:ItemHeap
		var multiple_occupied:bool
		for sub_row in arg_item_resource.size.y:
			for sub_column in arg_item_resource.size.x:
				var tar_position = Vector2(arg_grid.x+sub_column,arg_grid.y+sub_row)
				if item_table[tar_position] != null:
					if item_table[tar_position].item_resource == arg_item_resource:
						return item_table[tar_position]#当区间内第一次出现与鼠标控件类型一致的item时，返回该item进行操作
					elif occupied_item == null:
						occupied_item = item_table[tar_position]
					else:
						if occupied_item!=item_table[tar_position]:
							multiple_occupied = true
		if occupied_item!=null:#区间内检测到至少一个占用，且与鼠标控件都不符
			if multiple_occupied:#当区间内有多个占用时，无法操作，返回false
				return Case_Conflict
			else:#当区间内只有一个占用时，进行交换，返回待交换item
				return occupied_item
		else:
			if !exclusive_conflict():
				return Case_LayDirect#区间内为空，或槽位没有单一物品的限制可以直接放置，返回true
			else:
				return item_set[0]
			
func check_type(arg_item_resource:ItemResource)->bool:
	for black_tag in slot_resource.black_list:#黑名单优先级高于白名单
		if slot_resource.black_list[black_tag] ==true && arg_item_resource.has_tag(black_tag):
			return false#如果是黑名单种所禁止的类型，则必须剔除
	for white_tag in slot_resource.white_list:
		if slot_resource.white_list[white_tag]==true && !arg_item_resource.has_tag(white_tag):
			return false#如果不是白名单中所要求的类型，则必须剔除
	return true#只有同时通过黑、白名单校验的类型才可放行
			
			
			
			
			
			
######   Debug   ######
func CheckSlotSet():
	var line:String
	for item in item_set:
		line = line + "   " + item.item_resource.name+ "x" + str(item.amount)
	print(line)

func CheckSlotGrid():
	for row in slot_resource.grid_size.y:
		var slot_line:String
		for column in slot_resource.grid_size.x:
			if item_table[Vector2(column,row)]!=null:
				var format_string = "%12sx%2d"%[item_table[Vector2(column,row)].item_resource.id,item_table[Vector2(column,row)].amount]
				slot_line = slot_line + format_string
			else:
				slot_line = slot_line + "%15s"%"null"
				pass
		print(slot_line)
########################
