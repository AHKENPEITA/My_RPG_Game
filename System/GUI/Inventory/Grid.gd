extends Panel
#外部组件
var slot
#本地组件
var grid_container:GridContainer
var rect_container:Panel
var rect_dictionary:Dictionary

func _ready():
	grid_container = $GridContainer
	rect_container = $RectContainer
	pass
	
func _enter_tree():
	enter_add_listener()	
	
func _exit_tree():
	exit_remove_listener()

func enter_add_listener():
	EventCenter.AddListener(EventCenter.COM_RefreshDisplay,Callable(self,"refresh_panel"))

func exit_remove_listener():
	EventCenter.RemoveListener(EventCenter.COM_RefreshDisplay,Callable(self,"refresh_panel"))
	
	
func set_slot(arg_slot):
	slot = arg_slot
	update_rect_panel()
	
func update_rect_panel():
	if slot != null:
		for rect in rect_container.get_children():
			rect.queue_free()
		for item in slot.item_set:
			var rect = ItemCenter.load_item_rect(item,self)
			rect_container.add_child(rect)
			rect_dictionary[item.location] = rect
			rect.set_position(16*item.location)
	
func mouse_entered_slot(arg_slot):
	print(arg_slot.get_grid_position())
	pass

func refresh_panel():
	for cell in grid_container.get_children():
		cell.display_default()
	update_rect_panel()
	
func find_rect(arg_item):
	if rect_container.has(arg_item):
		return rect_dictionary[arg_item.grid]
		
######   通过网格坐标获取slot世界坐标的方法组   ######
func get_position_by_location(arg_location):
	return get_position_by_cell(get_cell_by_location(arg_location)) 
func get_position_by_cell(arg_cell):
	return arg_cell.global_position
func get_cell_by_location(arg_location:Vector2):
	return grid_container.get_child(arg_location.x+arg_location.y*grid_container.columns as int)
######      ######      ######
func get_inventory_panel():
	return get_parent().get_parent()
func get_gui_system():
	return get_inventory_panel().get_parent()
