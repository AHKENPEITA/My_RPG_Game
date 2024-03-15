extends SunCycleAnimationTree

@export var sun_rise_time_scale_path:String
@export var sun_set_time_scale_path:String
@export var sun_rise_time_scale:float
@export var sun_set_time_scale:float

func parameter_setting():
	var hour_length = TimeCenter.hour_length
	self[sun_rise_time_scale_path] = 1/(sun_rise_time_scale*hour_length)
	self[sun_set_time_scale_path] = 1/(sun_set_time_scale*hour_length)
	

