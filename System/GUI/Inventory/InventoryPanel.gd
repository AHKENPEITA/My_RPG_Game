extends Panel
@export var switch_animation:AnimationPlayer

func rise_in():
	switch_animation.play("RiseIn")
	pass
	
func rise_out():
	switch_animation.play("RiseOut")
	pass
	
func drop_in():
	switch_animation.play("DropIn")
	
func drop_out():
	switch_animation.play("DropOut")
