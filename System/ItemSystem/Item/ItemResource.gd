extends Resource
class_name  ItemResource
#参数
#General
@export var id:String#定位该物品种类的唯一标识符，不显示在游戏中，不是名字
@export var name:String#物品的名字，根据用户选择的语言有不同的本地化方案，不用于定位物品种类
@export var texture:Texture#贴图
@export var size:Vector2#占用的格子大小，ixj大小的整型
@export var stack_limit:int#物品堆叠上限，同一个格子无法堆叠超过该上限的物品
@export var weight:float#物品的重量，从小到大以两、斤、石为单位，进位制是16进制，用于推算角色的载荷和行走速度
@export var value:float#物品的固有价值，用来计算物品价格的基数
#Type和Item实际的Type并非一一对应的关系，此处的Type用于指定物品装备时的位置，而ItemType是决定物品本身类型属性的
@export var tag_list={"Hat":false,"Coat":false,"Trousers":false,"Boot":false,"Back":false,"Haversack":false,"Headwear":false,"Pandant":false,"Belt":false,"Bracelet":false,"Tool":false}
#Food
@export_group("Food")
@export_subgroup("NutrationValue", "nutration_value_")
@export_range(0, 20, 1, "or_greater") var nutration_value_grain:int
@export_range(0, 20, 1, "or_greater") var nutration_value_vegetable:int
@export_range(0, 20, 1, "or_greater") var nutration_value_fruit:int
@export_range(0, 20, 1, "or_greater") var nutration_value_meat:int
@export_range(0, 20, 1, "or_greater") var nutration_value_egg_milk:int
@export_range(0, 20, 1, "or_greater") var nutration_value_fat:int

#Equip
@export_group("Equip")
enum EquipType {Hat, Coat, Trousers, Boot, Back, Haversack, Headwear, Pandant, Belt, Bracelet}
@export var equip_type: EquipType

#Tool
@export_group("Tool")
@export_range(0, 255, 1, "or_greater") var durability

#Vessel
@export_group("Vessel")
@export var storage_id:String



############   以下是用以判断物品属性和类型的方法组   ############
func has_tag(arg_tag)->bool:#筛查物品标签
	for tag in tag_list:
		if tag==arg_tag && tag_list[tag]==true:
			return true
	return false
	
#筛查主类型的核心方法
func is_food():
	return nutration_value_grain + nutration_value_vegetable + nutration_value_fruit + nutration_value_meat + nutration_value_fat + nutration_value_egg_milk!=0
func is_equip():
	return equip_type!=0
func is_tool():
	return durability!=null
func is_vessel():
	return storage_id!=""
############   ############################   ############
