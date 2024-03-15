extends Panel
#上级组件
var possession:Node
#本地组件
@export var mouse_ui:Control
@export var left_prev_button:TextureButton
@export var right_prev_button:TextureButton
@export var left_next_button:TextureButton
@export var right_next_button:TextureButton
#以下是定位锚点
@export var left_slide:Control
@export var right_slide:Control
@export var left_current:Control
@export var left_incomming:Control
@export var left_leaving:Control
@export var right_current:Control
@export var right_incomming:Control
@export var right_leaving:Control
@export var side_panel:Control
@export var inventory_animation:AnimationPlayer
#变量
class State:

	enum{
		off,
		opening,
		on,
		closing
	}
var state = State.off
#var on:bool = false
var left_slidable = true
var right_slidable = true
#以下是面板指针
var left_current_panel
var left_incomming_panel
var left_leaving_panel
var right_current_panel
var right_incomming_panel
var right_leaving_panel

var left_panel_set = DataStructure.LinkedList.new()
var right_panel_set = DataStructure.LinkedList.new()
#
enum{
	GUI_Packing,#最经常用的背包整理界面
	GUI_Taking,#打开容器，拿取物品，进行整理的界面，类似于只保留了Gridcarrier的PanelBag
	GUI_Exchangeing,#与小队的角色交换物品，将所有属于Packing的Panel面板归到一侧，并同时打开两个，左侧对方，右侧己方，默认开启页面是BagPanel
	GUI_Dealing,#与商人进行交易，需要在中间打开结算清单
	GUI_Crafting,#手工制造物品/工作台GUI/烹饪GUI，该GUI界面无中间栏，左边栏扩展至中间，以便容纳下制造界面
	}
#Panel层面
@export var side_equipment_panel:Panel
@export var side_tool_panel:Panel
@export var side_inventory_panel:Panel
@export var side_container_panel:Panel


var animation_equip:AnimationPlayer
var animation_tool:AnimationPlayer

#Grid层面

var mouse_rect_relative_position:Vector2 = Vector2.ZERO
var cell_set = []

func ready_add_listener():
	EventCenter.AddListener(EventCenter.GUI_SwitchInventory,Callable(self,"packing_inventory"))
	EventCenter.AddListener(EventCenter.GUI_ContainerInventory,Callable(self,"container_inventory"))
	
	EventCenter.AddListener(EventCenter.COM_SetCharacter,Callable(self,"set_possession"))
	EventCenter.AddListener(EventCenter.ACT_ACCEPT,Callable(self,"accept"))
	EventCenter.AddListener(EventCenter.ACT_REJECT,Callable(self,"reject"))
	EventCenter.AddListener(EventCenter.ACT_PAGEUP,Callable(self,"page_up"))
	EventCenter.AddListener(EventCenter.ACT_PAGEDOWN,Callable(self,"page_down"))
	EventCenter.AddListener(EventCenter.ACT_PREVPAGE,Callable(self,"prev_page"))
	EventCenter.AddListener(EventCenter.ACT_NEXTPAGE,Callable(self,"next_page"))
	EventCenter.AddListener(EventCenter.ACT_Plus,Callable(self,"pick_once"))
	EventCenter.AddListener(EventCenter.ACT_Minus,Callable(self,"lay_once"))
	EventCenter.AddListener(EventCenter.ACT_5,Callable(self,"debug5"))
	
func exit_remove_listener():
	EventCenter.RemoveListener(EventCenter.GUI_SwitchInventory,Callable(self,"packing_inventory"))
	EventCenter.RemoveListener(EventCenter.GUI_ContainerInventory,Callable(self,"container_inventory"))
	
	EventCenter.RemoveListener(EventCenter.COM_SetCharacter,Callable(self,"set_possession"))
	EventCenter.RemoveListener(EventCenter.ACT_ACCEPT,Callable(self,"accept"))
	EventCenter.RemoveListener(EventCenter.ACT_REJECT,Callable(self,"reject"))
	EventCenter.RemoveListener(EventCenter.ACT_PAGEUP,Callable(self,"page_up"))
	EventCenter.RemoveListener(EventCenter.ACT_PAGEDOWN,Callable(self,"page_down"))
	EventCenter.RemoveListener(EventCenter.ACT_PREVPAGE,Callable(self,"prev_page"))
	EventCenter.RemoveListener(EventCenter.ACT_NEXTPAGE,Callable(self,"next_page"))
	EventCenter.RemoveListener(EventCenter.ACT_Plus,Callable(self,"pick_once"))
	EventCenter.RemoveListener(EventCenter.ACT_Minus,Callable(self,"lay_once"))
	EventCenter.RemoveListener(EventCenter.ACT_5,Callable(self,"debug5"))
	EventCenter.RemoveListener(EventCenter.COM_RefreshDisplay,Callable(self,"refresh_display"))
	

func _enter_tree():
	Global.inventory_gui = self

func _ready():
	ready_add_listener()
	for panel in side_panel.get_children():
		panel.global_position = side_panel.global_position

func _exit_tree():
	exit_remove_listener()

func _process(_delta):
	if has_mouse_rect():
		get_mouse_rect().global_position = get_viewport().get_mouse_position()+mouse_rect_relative_position


func packing_inventory():
	if state==State.off:
		state = State.opening
		EventCenter.BroadCast1(EventCenter.COM_CommandCharacter,false)
		open_as(GUI_Packing)
		open_inventory()
	elif state==State.on:
		state = State.closing
		close_inventory()
	
func container_inventory(arg_container):
	if state==State.off:
		state = State.opening
		EventCenter.BroadCast1(EventCenter.COM_CommandCharacter,false)
		side_container_panel.set_container(arg_container)
		side_container_panel.refresh_container_panel()
		open_as(GUI_Taking)
		open_inventory()

func global_reparent(arg_sub,arg_root):#把全局坐标与根节点对齐后再置换根节点
	arg_sub.global_position = arg_root.global_position
	arg_sub.reparent(arg_root)
	
func link_panel_to_side():
	global_reparent(left_current_panel.data,left_current)
	global_reparent(right_current_panel.data,right_current)

func open_as(arg_state):
	
	if arg_state == GUI_Packing:
		#在这里要把side_panel 加入正在使用的panel数组，然后设置side_panel的parent
		left_panel_set.append(side_equipment_panel)
		left_panel_set.append(side_tool_panel)
		left_current_panel = left_panel_set.head_node.next
		
		right_panel_set.append(side_inventory_panel)
		right_current_panel = right_panel_set.head_node.next
		link_panel_to_side()
		
	elif arg_state == GUI_Taking:
		left_panel_set.append(side_container_panel)
		left_current_panel = left_panel_set.head_node.next
		
		right_panel_set.append(side_inventory_panel)
		right_panel_set.append(side_equipment_panel)
		right_panel_set.append(side_tool_panel)
		right_current_panel = right_panel_set.head_node.next
		link_panel_to_side()
		
func open_inventory():
	EventCenter.BroadCast0(EventCenter.COM_RefreshCarrier)
	reset_left_prev_button_state()
	reset_left_next_button_state()
	reset_right_prev_button_state()
	reset_right_next_button_state()
	inventory_animation.play("Open")

func close_inventory():
	if has_mouse_rect():
			lay_back()
	inventory_animation.play("Close")
	EventCenter.BroadCast1(EventCenter.COM_CommandCharacter,true)

func open_over():
	state = State.on
	
func close_over():
	if (left_current_panel):
		left_current_panel.data.reparent(side_panel)
	left_panel_set.clear()
	if (right_current_panel):
		right_current_panel.data.reparent(side_panel)
	right_panel_set.clear()
	state = State.off
	
func set_possession(arg_character):
	possession = arg_character.possession
	side_equipment_panel.set_possession(possession)
	side_tool_panel.set_possession(possession)
	side_inventory_panel.set_possession(possession)

func page_up():
	if state==State.on:
		if position_in_panel(get_viewport().get_mouse_position(),side_inventory_panel.carrier_display_area):#鼠标在容器显示框里
			possession.carrier_manager.stepping_cycle(-1)
			EventCenter.BroadCast0(EventCenter.COM_RefreshCarrier)

func page_down():
	if state==State.on:
		if position_in_panel(get_viewport().get_mouse_position(),side_inventory_panel.carrier_display_area):#鼠标在容器显示框里
			possession.carrier_manager.stepping_cycle(1)
			EventCenter.BroadCast0(EventCenter.COM_RefreshCarrier)

###以下是左右页面翻页部分的逻辑
func prev_page():
	if state==State.on:
		if position_in_panel(get_viewport().get_mouse_position(),left_slide) && left_slidable:
			if left_have_prev_page():
				left_prev()
		if position_in_panel(get_viewport().get_mouse_position(),right_slide) && right_slidable:
			if right_have_prev_page():
				right_prev()
	
func next_page():
	if state==State.on:
		if position_in_panel(get_viewport().get_mouse_position(),left_slide):
			if left_have_next_page():
				left_next()
		if position_in_panel(get_viewport().get_mouse_position(),right_slide):
			if right_have_next_page():
				right_next()

func left_have_next_page()->bool:
	return left_panel_set.get_rear_node()!=left_current_panel
	
func right_have_next_page()->bool:
	return right_panel_set.get_rear_node()!=right_current_panel

func left_have_prev_page()->bool:
	return left_panel_set.head_node.next!=left_current_panel
	
func right_have_prev_page()->bool:
	return right_panel_set.head_node.next!=right_current_panel

func left_prev():
	if left_slidable:
		left_slidable = false
		left_leaving_panel = left_current_panel
		left_incomming_panel = left_current_panel.prev
		global_reparent(left_leaving_panel.data,left_leaving)
		global_reparent(left_incomming_panel.data,left_incomming)
		inventory_animation.play("LeftPrev")

func left_next():
	if left_slidable:
		left_slidable = false
		left_leaving_panel = left_current_panel
		left_incomming_panel = left_current_panel.next
		global_reparent(left_leaving_panel.data,left_leaving)
		global_reparent(left_incomming_panel.data,left_incomming)
		inventory_animation.play("LeftNext")

func right_prev():
	if right_slidable:
		right_slidable = false
		right_leaving_panel = right_current_panel
		right_incomming_panel = right_current_panel.prev
		global_reparent(right_leaving_panel.data,right_leaving)
		global_reparent(right_incomming_panel.data,right_incomming)
		inventory_animation.play("RightPrev")

func right_next():
	if right_slidable:
		right_slidable = false
		right_leaving_panel = right_current_panel
		right_incomming_panel = right_current_panel.next
		global_reparent(right_leaving_panel.data,right_leaving)
		global_reparent(right_incomming_panel.data,right_incomming)
		inventory_animation.play("RightNext")

func _on_left_prev_button_button_down():
	left_prev()

func _on_left_next_button_button_down():
	left_next()

func _on_right_prev_button_button_down():
	right_prev()

func _on_right_next_button_button_down():
	right_next()


func left_slide_over():
	left_current_panel = left_incomming_panel
	global_reparent(left_current_panel.data,left_current)
	global_reparent(left_leaving_panel.data,side_panel)
	left_slidable = true
	reset_left_prev_button_state()
	reset_left_next_button_state()
	
func right_slide_over():
	right_current_panel = right_incomming_panel
	global_reparent(right_current_panel.data,right_current)
	global_reparent(right_leaving_panel.data,side_panel)
	right_slidable = true
	reset_right_prev_button_state()
	reset_right_next_button_state()
	
func reset_left_prev_button_state():
	if left_have_prev_page():
		left_prev_button.disabled = false
	else:
		left_prev_button.disabled = true
	
func reset_left_next_button_state():
	if left_have_next_page():
		left_next_button.disabled = false
	else:
		left_next_button.disabled = true
		
func reset_right_prev_button_state():
	if right_have_prev_page():
		right_prev_button.disabled = false
	else:
		right_prev_button.disabled = true
		
func reset_right_next_button_state():
	if right_have_next_page():
		right_next_button.disabled = false
	else:
		right_next_button.disabled = true
###翻页逻辑结束

func pick_once():
	if visible:
		var tar_cell = get_cell_by_position(get_viewport().get_mouse_position(),0.5)
		if tar_cell!=null:
			var tar_grid = tar_cell.grid
			var tar_slot = tar_grid.slot
			var tar_item = tar_slot.item_table[tar_cell.get_location()]
			if tar_item!=null:
				var tar_rect = tar_grid.rect_dictionary[tar_item.location]
				if !has_mouse_rect():
					if tar_slot.pick_item_once(tar_item):
						tar_rect.queue_free()
					else:
						tar_rect.refresh_rect()
					
					var new_item = ItemHeap.new(tar_item.item_resource,1)
					new_item.set_slot_position(tar_item.slot,tar_item.location)
					var new_rect = ItemCenter.load_item_rect(new_item,tar_grid)
					set_mouse_rect(new_rect)
					mouse_rect_relative_position = -0.5*new_rect.size
				else:
					if get_mouse_rect().item.item_resource == tar_rect.item.item_resource:
						if get_mouse_rect().item.amount<get_mouse_rect().item.item_resource.stack_limit:
							if tar_slot.pick_item_once(tar_item):
								tar_rect.queue_free()
							else:
								tar_rect.refresh_rect()
							get_mouse_rect().item.set_slot_position(tar_slot,tar_item.location)
							get_mouse_rect().item.amount+=1
							get_mouse_rect().refresh_rect()

func lay_once():#放置时要检测类型是否匹配，不匹配则无法放置
	if visible && has_mouse_rect():
		var tar_cell = get_cell_by_position(get_mouse_rect().global_position,0)
		if tar_cell==null:
			excess_of_stroke()
		else:
			var tar_grid = tar_cell.grid
			var tar_slot = tar_grid.slot
			var check_result = tar_slot.check_lay_space(get_mouse_rect().item.item_resource,tar_cell.get_location())
			match check_result:
				tar_slot.Case_ExcessOfStroke:
					excess_of_stroke()
					pass
				tar_slot.Case_Conflict:
#					print("与两个以上物件发生冲突，不放置")
					pass
				tar_slot.Case_TypeNotMatch:
#					print("与目标空间类型冲突，不放置")
					pass
				tar_slot.Case_LayDirect:
#					print("目标空间无Rect，直接放置")
					tar_slot.set_item_to(ItemHeap.new(get_mouse_rect().item.item_resource,1),tar_cell.get_location())
					if get_mouse_rect().item.amount>1:
						get_mouse_rect().item.amount-=1
						get_mouse_rect().refresh_rect()
					else:
						clear_mouse_rect()
					EventCenter.BroadCast0(EventCenter.COM_RefreshDisplay)
				_:
					if check_result.item_resource == get_mouse_rect().item.item_resource:
						if check_result.amount<check_result.item_resource.stack_limit:
							check_result.amount+=1
							EventCenter.BroadCast0(EventCenter.COM_RefreshDisplay)
							if get_mouse_rect().item.amount>1:
								get_mouse_rect().item.amount-=1
								get_mouse_rect().refresh_rect()
							else:
								clear_mouse_rect()
						pass
					else:
						pass

func accept():
	if visible:
		var tar_cell = get_tar_cell()
		if tar_cell != null:
#			print(tar_cell.grid.get_parent())
			call_slot(tar_cell)
		else:
			if has_mouse_rect() && !position_in_panel(get_viewport().get_mouse_position(),self):
				drop_rect()
			else:
				excess_of_stroke()

func reject():
	if has_mouse_rect():
		lay_back()

######  用于获取交互slot对象的方法组  ######
func get_tar_cell():
	if !has_mouse_rect():#鼠标控件无物品时，以鼠标指针作为锚点获取其坐标
		return get_cell_by_position(get_viewport().get_mouse_position(),0.5)
	else:#鼠标控件有物品时，以物品焦点作为锚点获取其坐标
		return get_cell_by_position(get_mouse_rect().global_position,0)
func get_cell_by_position(arg_global_position,arg_modifiction):
	for cell in cell_set:
		if ((arg_global_position-cell.global_position-arg_modifiction*cell.size).abs().x<=0.5*cell.size.x)&&((arg_global_position-cell.global_position-arg_modifiction*cell.size).abs().y<=0.5*cell.size.y)&&cell.grid.get_parent().visible:
			return cell#传入锚点坐标，匹配符合坐标的cell
func get_position_by_cell(arg_cell):
	for cell in cell_set:
		if cell == arg_cell:
			return cell.global_position
######################################################

func excess_of_stroke():#锚点定位坐标来到slot范围以外时的情况
#	print("超程的交互，不做操作")
	pass

func drop_rect():#鼠标坐标在物品栏以外时，丢弃手上的物品（待完善，还未添加生成被丢弃物品的世界实体的方法）
	print("丢弃"+str(get_mouse_rect().item.amount)+"个"+str(get_mouse_rect().item.item_resource.name))
	clear_mouse_rect()

func call_slot(arg_cell):
	var tar_grid = arg_cell.grid
	var tar_slot = tar_grid.slot
	if !has_mouse_rect():#当鼠标控件上无物品，坐标对应item不为空时，捡起该Rect
		var tar_item = tar_slot.item_table[arg_cell.get_location()]
		if tar_item!=null:
			var tar_rect = tar_grid.rect_dictionary[tar_slot.item_table[arg_cell.get_location()].location]
			pick_up(tar_rect)
	else:#当鼠标控件上有物品时
		var check_result =  tar_slot.check_lay_space(get_mouse_rect().get_item().item_resource,arg_cell.get_location())
		match check_result:
			tar_slot.Case_LayDirect:#目标空间为空时，放置
				lay_to(tar_slot,tar_grid,arg_cell.get_location())
			tar_slot.Case_Conflict:#目标空间不为空时（多个，无一相同），拒绝
				pass
			tar_slot.Case_TypeNotMatch:#与目标空间的类型不匹配,拒绝
				pass
			tar_slot.Case_ExcessOfStroke:#指向了格子以外时，丢弃
				excess_of_stroke()
			_:#返回可交互对象时（目标空间存在一个不同类或存在一个同类）
				if check_result.item_resource == get_mouse_rect().item.item_resource:#对象格子不为空时（多个，存在相同），尝试归并
					merge(check_result)
				else:
					exchange_rect(tar_slot,tar_grid,check_result,arg_cell.get_location())

func pick_up(arg_rect):
	arg_rect.get_grid().slot.pick_item_up(arg_rect.item)
	set_mouse_rect(arg_rect)
	get_mouse_rect().reparent(mouse_ui)
	mouse_rect_relative_position = get_mouse_rect().global_position-get_viewport().get_mouse_position()
	
func lay_to(arg_slot,arg_grid,arg_location):
	arg_slot.set_item_to(get_mouse_rect().get_item(),arg_location)
	var arg_rect = get_mouse_rect()
	arg_rect.reparent(arg_grid.rect_container)
	arg_rect.set_grid(arg_grid)
	arg_rect.get_grid().rect_dictionary[arg_rect.item.location] = arg_rect
	arg_rect.set_global_position(arg_grid.get_position_by_location(arg_location))
	clear_mouse_rect()
	pass

func exchange_rect(arg_slot,arg_grid,arg_picking_item,arg_location):
	var mouse_rect = get_mouse_rect()
	var picking_rect = arg_grid.rect_dictionary[arg_picking_item.location]
	arg_slot.exchange_item(arg_picking_item,get_mouse_rect().item,arg_location)
	
	mouse_rect.reparent(arg_grid.rect_container)
	mouse_rect.set_grid(arg_grid)
	arg_grid.rect_dictionary[arg_location] = mouse_rect
	mouse_rect.set_global_position(arg_grid.get_position_by_location(arg_location))
	clear_mouse_rect()
	
	set_mouse_rect(picking_rect)
	get_mouse_rect().reparent(mouse_ui)
	mouse_rect_relative_position = -0.5*get_mouse_rect().size

func merge(arg_item):
	var amount_remaining = arg_item.slot.merge_with(get_mouse_rect().item,arg_item)
	EventCenter.BroadCast0(EventCenter.COM_RefreshDisplay)
	if amount_remaining == 0:
		clear_mouse_rect()
		return true
	else:
		get_mouse_rect().item.amount = amount_remaining
		get_mouse_rect().refresh_rect()
		return false

func lay_back():
	var tar_slot = get_mouse_rect().item.slot
	var lay_back_result = get_mouse_rect().item.slot.check_lay_space(get_mouse_rect().item.item_resource,get_mouse_rect().item.location)
	match lay_back_result:
		tar_slot.Case_ExcessOfStroke:
#			print("不可能")
			pass
		tar_slot.Case_Conflict:
			print("不可能")
			pass
		tar_slot.Case_LayDirect:
#			print("拿完掉的情况")
			lay_to(tar_slot,get_mouse_rect().grid,get_mouse_rect().item.location)
			pass
		_:
			if lay_back_result.item_resource == get_mouse_rect().item.item_resource:
#				print("未拿完的情况")
				if !merge(lay_back_result):#鼠标没有完全清空的情况
#					print("鼠标没有完全清空的情况")
					var amount_remaining = tar_slot.AddMultiple(get_mouse_rect().item.item_resource,get_mouse_rect().item.amount)
					if amount_remaining==0:
						clear_mouse_rect()
					else:
						drop_rect()
				else:
#					print("放回后完全清空的情况")
					pass
			else:
				var amount_remaining = tar_slot.AddMultiple(get_mouse_rect().item.item_resource,get_mouse_rect().item.amount)
				if amount_remaining==0:
					clear_mouse_rect()
				else:
					drop_rect()
#				print("交换后又要求放回的情况")


######   Basic Function   ######

func has_mouse_rect()->bool:
	if mouse_ui.get_child_count()!=0:
		return true
	else:
		return false
	
func get_mouse_rect():
	if has_mouse_rect():
		return mouse_ui.get_child(0)
	else:
		return null

func set_mouse_rect(arg_rect):
	if arg_rect.get_parent()!=null:
		arg_rect.reparent(mouse_ui)
	else:
		mouse_ui.add_child(arg_rect)
	
func new_mouse_rect(arg_item,arg_grid):
	set_mouse_rect(ItemCenter.load_item_rect(arg_item,arg_grid))
	mouse_rect_relative_position = -0.5*get_mouse_rect().size
	
func clear_mouse_rect():
	if has_mouse_rect():
		get_mouse_rect().queue_free()
	mouse_rect_relative_position = Vector2.ZERO

func add_cell(arg_cell):
	cell_set.append(arg_cell)
	
######   Debug方法   ######
func CheckPickSlot():
	if has_mouse_rect():
		print("抓手里有",get_mouse_rect().item.amount,"个"+get_mouse_rect().item.item_resource.name)
	else:
		print("抓手里是空的")

func debug5():
		CheckPickSlot()
		pass

func position_in_panel(arg_position,arg_panel):
	var left = arg_position.x>=arg_panel.global_position.x
	var right = arg_position.x<=arg_panel.global_position.x+arg_panel.size.x
	var up = arg_position.y>=arg_panel.global_position.y
	var down = arg_position.y<=arg_panel.global_position.y+arg_panel.size.y
	return left && right && up && down
##################



