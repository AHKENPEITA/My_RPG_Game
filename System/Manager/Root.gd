extends Node 
#本地组件

#外部组件
var CurrentCharacter

var MainCamera
var GUI
var World
#状态
#参数
var input_vector = Vector2.ZERO

#监听器装卸
func ready_add_listener():
	EventCenter.AddListener(EventCenter.ACT_1,Callable(self,"debug1"))
	EventCenter.AddListener(EventCenter.ACT_2,Callable(self,"debug2"))
	EventCenter.AddListener(EventCenter.ACT_3,Callable(self,"debug3"))
	EventCenter.AddListener(EventCenter.ACT_4,Callable(self,"debug4"))
func exit_remove_listener():
	EventCenter.RemoveListener(EventCenter.ACT_1,Callable(self,"debug1"))
	EventCenter.RemoveListener(EventCenter.ACT_2,Callable(self,"debug2"))
	EventCenter.RemoveListener(EventCenter.ACT_3,Callable(self,"debug3"))
	EventCenter.RemoveListener(EventCenter.ACT_4,Callable(self,"debug4"))
#外部方法

#初始化、物理帧、动画帧、结束
func _enter_tree():
	Global.root = self

func _ready():
	GUI = $GUI
	World = $World
	MainCamera = $MainCamera
	set_command_character(World.get_default_character())
	ready_add_listener()

func _process(_delta):
	pass	
	
func _exit_tree():
	exit_remove_listener()
#本地方法
func debug1():
	change_player_character($World.find_Character("Character"))
	print("debug1")
	pass
func debug2():
	change_player_character($World.find_Character("Character2"))
	print("debug2")
	pass
	
func debug3():
	$World.find_Character("Character").possession.AddMultiple(ItemCenter.find_item_resource("TestItem2x1"),1)
	$World.find_Character("Character").possession.AddMultiple(ItemCenter.find_item_resource("BerryFruit"),5)
	$World.find_Character("Character").possession.AddMultiple(ItemCenter.find_item_resource("TestItem4x2"),1)
	$World.find_Character("Character").possession.AddMultiple(ItemCenter.find_item_resource("TestItem4x1"),1)
	$World.find_Character("Character").possession.AddMultiple(ItemCenter.find_item_resource("TestCoat"),1)
	$World.find_Character("Character").possession.AddMultiple(ItemCenter.find_item_resource("TestTrousers"),1)
	$World.find_Character("Character").possession.AddMultiple(ItemCenter.find_item_resource("TestItem1x1"),3)
	print("debug3")

func debug4():
	$World.find_Character("Character2").possession.AddMultiple(ItemCenter.find_item_resource("TestBackPackMidium"),1)
	$World.find_Character("Character2").possession.AddMultiple(ItemCenter.find_item_resource("TestHaversack"),1)
	$World.find_Character("Character2").possession.AddMultiple(ItemCenter.find_item_resource("TestItem3x2"),1)
	$World.find_Character("Character2").possession.AddMultiple(ItemCenter.find_item_resource("TestItem1x1"),3)
	$World.find_Character("Character2").possession.AddMultiple(ItemCenter.find_item_resource("TestItem2x2"),1)
	$World.find_Character("Character2").possession.AddMultiple(ItemCenter.find_item_resource("TestItem2x3"),1)
	print("debug4")

func set_command_character(arg_character):
	CurrentCharacter = arg_character
	EventCenter.BroadCast1(EventCenter.COM_SetCharacter,CurrentCharacter)
	
func change_player_character(arg_character):
	CurrentCharacter = arg_character
	EventCenter.BroadCast1(EventCenter.COM_SetCharacter,CurrentCharacter)
