extends Area2D
@export var transparent_shape:CollisionShape2D
@export var min_transparent_distant_threshold:float
@export var min_transparent_ratio:float

#var character:CharacterBody2D
var body_set = []

var distance:float
var rate:float
var alpha_rate:float
signal transparent_parameter

func _on_body_entered(arg_body):
	if !body_set.has(arg_body):
		body_set.append(arg_body)
		#prints("1:",body_set)
	
func _on_body_exited(arg_body):
	if body_set.has(arg_body):
		body_set.erase(arg_body)
		

func _process(_delta):
	for body in body_set:
		if body == CharacterManager.character:
			distance = body.global_position.distance_to(self.global_position)
			rate = min(max((distance/transparent_shape.shape.radius - min_transparent_distant_threshold)/(1-min_transparent_distant_threshold),0),1)
			alpha_rate = rate*(1-min_transparent_ratio)+min_transparent_ratio
			emit_signal("transparent_parameter",alpha_rate)
			#print(sprite.self_modulate.a)
