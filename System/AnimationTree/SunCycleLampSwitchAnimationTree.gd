extends SunCycleAnimationTree

@export var delay_hour:float
var delay:float
var sun_rise_timer:float
var sun_set_timer:float

func parameter_setting():
	delay = delay_hour*TimeCenter.hour_length
	sun_rise_timer = 0
	sun_set_timer = 0
	
func sun_rise_update():
	sun_rise_timer = delay
	
func sun_set_update():
	sun_set_timer = delay
	
func _process(delta):
	if sun_rise_timer>0:
		sun_rise_timer-=delta
		if sun_rise_timer<=0:
			sun_rise_timer = 0;
			self[sun_rise_condition] = true
			self[sun_set_condition]  = false
	if sun_set_timer>0:
		sun_set_timer-=delta
		if sun_set_timer<=0:
			sun_set_timer = 0;
			self[sun_rise_condition] = false
			self[sun_set_condition]  = true
		
	
