extends Label
var timer

func _ready():
	timer = $Timer
	

func pop_dialog(arg_text):
	text = arg_text
	visible = true
	timer.start(2)


func _on_timer_timeout():
	visible = false
	pass # Replace with function body.
