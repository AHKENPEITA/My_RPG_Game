extends Panel
var possession
var carrier_rect
@export var grid_belongings:Panel
@export var carrier_display_area:Control
@export var storage_panel_area:Control
@export var carrier_name_label:Label
@export var storage_name_label:Label
@export var carrier_default_name:String
@export var storage_default_name:String
var storage_panel_path = LoadPathCenter.storage_panel_path

func _ready():
	load_carrier_panel()
	
	
func _enter_tree():
	EventCenter.AddListener(EventCenter.COM_RefreshCarrier,Callable(self,"refresh_carrier"))
	
func _exit_tree():
	EventCenter.RemoveListener(EventCenter.COM_RefreshCarrier,Callable(self,"refresh_carrier"))

func set_possession(arg_possession):#载入目标character的possession
	possession = arg_possession
	grid_belongings.set_slot(possession.belongings)
	
func load_carrier_panel():#载入所有待使用的vesel_panel
	var storage_panel_array = DirAccess.get_files_at(storage_panel_path)
	for storage_panel in storage_panel_array:
		var loading_storage_panel = load("{storage_panel_path}{storage_panel}".format({"storage_panel_path":storage_panel_path,"storage_panel":storage_panel})).instantiate()
		loading_storage_panel.visible = false
		storage_panel_area.add_child(loading_storage_panel)

func refresh_carrier():
	for panel in storage_panel_area.get_children():
		panel.visible = false
	if possession!=null:
		if possession.carrier_manager.has_carrier():
			var carrier = possession.carrier_manager.flag_node.carrier
			var storage_id = carrier.storage.storage_resource.storage_id
			var panel_display = null
			carrier_name_label.text = carrier.item.item_resource.name
			storage_name_label.text = carrier.storage.storage_resource.storage_name
			for panel in storage_panel_area.get_children():
				if panel.name ==storage_id:
					panel_display = panel
					break
			for index in panel_display.get_children().size():
				panel_display.get_children()[index].set_slot(carrier.storage.slot_set[index])
				panel_display.get_children()[index].refresh_panel()
			panel_display.visible = true
			
			###在此插入当前聚焦的容器的图标
			if carrier_rect!=null:
				carrier_rect.queue_free()
			carrier_rect = ItemCenter.load_item_rect(carrier.item,carrier_display_area)
			carrier_display_area.add_child(carrier_rect)
			
		else:
			carrier_name_label.text = carrier_default_name
			storage_name_label.text = storage_default_name
			if carrier_rect!=null:
				carrier_rect.queue_free()
			
