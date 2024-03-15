extends TileMap
var growable_custom_data = "Growable"

func _ready():
	var used_cell_coords = get_used_cells(0)
	var growable_coords = []
	for coord in used_cell_coords:
		var tile_data = get_cell_tile_data(0,coord)
		if tile_data:
			if tile_data.get_custom_data(growable_custom_data):
				#print(tile_data.get_custom_data(growable_custom_data))
				growable_coords.append(coord)
	Global.entity_container.set_growable(growable_coords)
