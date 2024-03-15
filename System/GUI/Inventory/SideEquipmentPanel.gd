extends Panel
#本地组件
var possession
@export var grid_hat:Panel
@export var grid_coat:Panel
@export var grid_trousers:Panel
@export var grid_boot:Panel
@export var grid_back:Panel
@export var grid_haversack:Panel
@export var grid_headwear:Panel
@export var grid_pandant:Panel
@export var grid_belt:Panel
@export var grid_bracelet:Panel
@export var switch_animation:AnimationPlayer

func set_possession(arg_possession):
	possession = arg_possession
	grid_hat.set_slot(possession.hat)
	grid_coat.set_slot(possession.coat)
	grid_trousers.set_slot(possession.trousers)
	grid_boot.set_slot(possession.boot)
	grid_back.set_slot(possession.back)
	grid_haversack.set_slot(possession.haversack)
	grid_headwear.set_slot(possession.headwear)
	grid_pandant.set_slot(possession.pandant)
	grid_belt.set_slot(possession.belt)
	grid_bracelet.set_slot(possession.bracelet)
