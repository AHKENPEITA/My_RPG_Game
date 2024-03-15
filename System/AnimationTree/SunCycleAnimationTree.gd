class_name SunCycleAnimationTree extends AnimationTree
#用昼夜循环报时系统控制动画的开关状态的动画树
#开和关的时间点（由TimeCenter的小时报时激活）可以自定义
#可用于昼夜循环动画、路灯开关动画以及有相似逻辑的动画
@export var sun_rise_condition:String
@export var sun_set_condition:String

func _ready():
	EventCenter.AddListener(EventCenter.TIME_SunRise,Callable(self,"sun_rise_update"))
	EventCenter.AddListener(EventCenter.TIME_SunSet,Callable(self,"sun_set_update"))
	parameter_setting()
	begin_update()
	
	
func _exit_tree():
	EventCenter.RemoveListener(EventCenter.TIME_SunRise,Callable(self,"sun_rise_update"))
	EventCenter.RemoveListener(EventCenter.TIME_SunSet,Callable(self,"sun_set_update"))

func begin_update():
	if TimeCenter.sun_set || !TimeCenter.sun_rise:
		self[sun_rise_condition]  = false
		self[sun_set_condition] = true
	else:
		self[sun_rise_condition]  = true
		self[sun_set_condition] = false

func parameter_setting():
	pass

func sun_rise_update():
	self[sun_rise_condition]  = true
	self[sun_set_condition] = false
	
func sun_set_update():
	self[sun_rise_condition]  = false
	self[sun_set_condition] = true


