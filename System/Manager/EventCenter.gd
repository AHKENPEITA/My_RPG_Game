extends Node
#事件库
var EventTable  = {}
func AddListener(arg_EventType,arg_callable:Callable):
	if !EventTable.has(arg_EventType):
		EventTable[arg_EventType] = [arg_callable]
	else :
			EventTable[arg_EventType].append(arg_callable)

func RemoveListener(arg_EventType,arg_callable:Callable):
	if!EventTable.has(arg_EventType):
		push_error("移除监听错误：事件库中不存在事件：",arg_EventType)
	elif EventTable[arg_EventType] ==null:
		push_error("移除监听错误：事件：",arg_EventType,"下没有挂载任何回调")
	else :
		var target_callable = EventTable[arg_EventType].find(arg_callable)
		if target_callable ==-1:
			push_error("移除监听错误：事件",arg_EventType,"下没有挂载回调：",arg_callable)
		else :
			EventTable[arg_EventType].erase(arg_callable)
			if EventTable[arg_EventType].is_empty():
				EventTable.erase(arg_EventType)

func BroadCast0(arg_EventType):
	if EventTable.has(arg_EventType):
		if EventTable[arg_EventType]!=null:
			for callback in EventTable[arg_EventType]:
				callback.call()

func BroadCast1(arg_EventType,arg1):
	if EventTable.has(arg_EventType):
		if EventTable[arg_EventType]!=null:
			for callback in EventTable[arg_EventType]:
				callback.call(arg1)

func BroadCast2(arg_EventType,arg1,arg2):
	if EventTable.has(arg_EventType):
		if EventTable[arg_EventType]!=null:
			for callback in EventTable[arg_EventType]:
				callback.call(arg1,arg2)

func BroadCast3(arg_EventType,arg1,arg2,arg3):
	if EventTable.has(arg_EventType):
		if EventTable[arg_EventType]!=null:
			for callback in EventTable[arg_EventType]:
				callback.call(arg1,arg2,arg3)

enum{	
	####新的KEY机制
	KEY_ML,
	KEY_MR,
	KEY_MM,
	KEY_MU,
	KEY_MD,
	KEY_MN,
	KEY_MP,
	KEY_A,
	KEY_B,
	KEY_C,
	KEY_D,
	KEY_E,
	KEY_F,
	KEY_G,
	KEY_H,
	KEY_I,
	KEY_J,
	KEY_K,
	KEY_L,
	KEY_M,
	KEY_N,
	KEY_O,
	KEY_P,
	KEY_Q,
	KEY_R,
	KEY_S,
	KEY_T,
	KEY_U,
	KEY_V,
	KEY_W,
	KEY_X,
	KEY_Y,
	KEY_Z,
	KEY_1,
	KEY_2,
	KEY_3,
	KEY_4,
	KEY_5,
	KEY_6,
	KEY_7,
	KEY_8,
	KEY_9,
	KEY_0,
	KEY_Space,
	KEY_Enter,
	KEY_Backspace,
	KEY_Esc,
	KEY_Delete,
	KEY_Shift,
	KEY_Ctrl,
	KEY_Alt,
	KEY_CapsLk,
	
	ACT_ACCEPT,
	ACT_REJECT,
	ACT_PAGEUP,
	ACT_PAGEDOWN,
	ACT_Plus,
	ACT_Minus,
	ACT_NEXTPAGE,
	ACT_PREVPAGE,
	ACT_TAKE,
	ACT_TOOL,
	ACT_POWER,
	ACT_DASH,
	ACT_MOVE,
	ACT_1,
	ACT_2,
	ACT_3,
	ACT_4,
	ACT_5,
	ACT_6,
	ACT_7,
	ACT_8,
	ACT_9,
	ACT_0,
	GUI_SwitchInventory,#打开/切换为/关闭玩家物品栏GUI
	GUI_ContainerInventory,#打开/关闭玩家容器GUI
	COM_SetCharacter,#设定当前操作角色的命令，单参，待设定角色的Node2D组件
	COM_CommandCharacter,#设定当前人物是否可以控制
	COM_ReloadInteractor,#当交互完成后，通知角色交互传感器更新
	COM_PlaySound,#用来通知全局UI音效播放器播放声音。单参，String类型，声音文件的名字，不包含路径和后缀
	COM_RefreshDisplay,#通知GUI界面刷新显示(卸载后又重新加载，会把所有rect释放掉)
	COM_RefreshCarrier,#通知物品栏GUI界面刷新容器展板的显示
	
	TIME_Oclock,#时间中心钟点更新
	TIME_QuarterDay,#时间中心四分之一日更新
	TIME_Day,#时间中心每日更新
	TIME_Year,#时间中心每年更新
	TIME_SunRise,#时间中心日出信号
	TIME_SunSet,#时间中心日落信号
	
	
}

func debug():
	pass
