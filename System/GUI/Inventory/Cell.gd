extends ColorRect
var grid_container:GridContainer
var grid:Panel
var inventory_gui:Panel
var default_color = Color.html("ffffff00")
var hovering_color = Color.html("ffffff00")
var click_lock = 0

func _ready():
	grid_container = get_parent()
	grid = grid_container.get_parent()
	inventory_gui = Global.inventory_gui
	
	color = default_color
	inventory_gui.add_cell(self)
	
	
func _enter_tree():
	pass
	
func _exit_tree():
	pass	
	
func display_hovering():
	color = hovering_color
	
func display_default():
	color = default_color

func anchor_position()->Vector2:
	return global_position+0.5*size
	
func get_location()->Vector2:
	return Vector2(get_index()%get_parent().columns,get_index()/get_parent().columns)
