class_name Interector extends Node2D
var interactable:bool
var location
signal interect

func _ready():
	set_interactor()

func set_interactor():
	location = position_to_location(self.global_position)
	Global.entity_container.add_interactor(self)
	
func interact(arg_character):
	emit_signal("interect",arg_character)
	
func set_interactable(arg_bool):
	interactable = arg_bool
	EventCenter.BroadCast0(EventCenter.COM_ReloadInteractor)
	
func position_to_location(arg_position)->Vector2:
	var x=(floorf(arg_position.x/16))
	var y=(floorf(arg_position.y/16))
	return Vector2(x,y)
