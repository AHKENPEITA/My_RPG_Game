extends TextureRect
class_name Rect
var grid
var item

func _ready():
	pass
	
func _enter_tree():
	pass
func _exit_tree():
	pass
	
func set_rect(arg_item,arg_grid):
	if arg_item!=null:
		item = arg_item
		grid = arg_grid
		texture = item.item_resource.texture
		if item.amount!=1:
			$AmountLabel.text = str(item.amount)
		else:
			$AmountLabel.text = ""
	else:
		texture = null
		$AmountLabel.text = ""

func set_grid(arg_grid):
	grid = arg_grid

func get_grid():
	return grid
	
func get_item():
	return item
	
func refresh_rect():
	texture = item.item_resource.texture
	if item.amount!=1:
		$AmountLabel.text = str(item.amount)
	else:
		$AmountLabel.text = ""
