extends Camera2D
#变量
var focus:Node2D
#监听管理
func ready_add_listener():
	EventCenter.AddListener(EventCenter.COM_SetCharacter,Callable(self,"set_focus"))
func exit_remove_listener():
	EventCenter.RemoveListener(EventCenter.COM_SetCharacter,Callable(self,"set_focus"))
#监听方法
func set_focus(arg_character):
	focus = arg_character
#初始化、退场、物理帧、动画帧
func _enter_tree():
	Global.main_camera = self

func _ready():
	ready_add_listener()
	pass
	
func _exit_tree():	
	exit_remove_listener()
	pass
	
func _process(_delta):
	position = focus.global_position
	pass
	

	
	
	
	
	
	
	
	
	
	
	
	
