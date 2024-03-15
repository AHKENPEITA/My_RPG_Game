extends Resource
class_name SlotResource
var storage:Node
#本地组件
var item_set:Array
var item_grid:Dictionary
#本地参数
@export var slot_id:String
@export var grid_size:Vector2
@export var is_carrier_port:bool#决定该slot是否可以打开容器
@export var is_exclusive:bool#槽位是否专用，专用槽位只接受单个物品，无论空间大小（主要用于装备、武器栏位，特殊：手链栏位，因为要放置左右手链，所以不必设置为孤立；头饰栏位，若是耳环的话，可以佩戴左右不同的耳环）
@export var black_list = {"Hat":false,"Coat":false,"Trousers":false,"Boot":false,"Back":false,"Haversack":false,"Headwear":false,"Pandant":false,"Belt":false,"Bracelet":false,"Tool":false}
@export var white_list = {"Hat":false,"Coat":false,"Trousers":false,"Boot":false,"Back":false,"Haversack":false,"Headwear":false,"Pandant":false,"Belt":false,"Bracelet":false,"Tool":false}

