extends Panel
var possession
@export var grid_tool_main1:Panel
@export var grid_tool_main2:Panel
@export var grid_tool_vice1:Panel
@export var grid_tool_vice2:Panel

func set_possession(arg_possession):
	possession = arg_possession
	grid_tool_main1.set_slot(possession.tool_main1)
	grid_tool_main2.set_slot(possession.tool_main2)
	grid_tool_vice1.set_slot(possession.tool_vice1)
	grid_tool_vice2.set_slot(possession.tool_vice2)
