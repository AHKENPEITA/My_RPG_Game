extends Panel

var storage
@export var storage_panel_area:Control
@export var container_name_label:Label
var storage_panel_path = LoadPathCenter.storage_panel_path

func _ready():
	load_storage_panel()

func set_container(arg_container):
	storage = arg_container.storage
	container_name_label.text = arg_container.storage.storage_resource.storage_name
	#print(storage)
	
func load_storage_panel():#载入所有待使用的vesel_panel
	var storage_panel_array = DirAccess.get_files_at(storage_panel_path)
	for storage_panel in storage_panel_array:
		var loading_storage_panel = load("{storage_panel_path}{storage_panel}".format({"storage_panel_path":storage_panel_path,"storage_panel":storage_panel})).instantiate()
		loading_storage_panel.visible = false
		storage_panel_area.add_child(loading_storage_panel)

func refresh_container_panel():
	
	for panel in storage_panel_area.get_children():
		panel.visible = false
	if storage!=null:
		#print(storage)
		var storage_id = storage.storage_resource.storage_id
		var panel_display = null
		for panel in storage_panel_area.get_children():
			if panel.name ==storage_id:
				panel_display = panel
				break
		for index in panel_display.get_children().size():
			panel_display.get_children()[index].set_slot(storage.slot_set[index])
			panel_display.get_children()[index].refresh_panel()
		panel_display.visible = true
