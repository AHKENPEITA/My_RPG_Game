extends Node
var character
var on_command = true
var move_vector = Vector2.ZERO

func ready_add_listener():
	EventCenter.AddListener(EventCenter.COM_SetCharacter,Callable(self,"set_character"))
	EventCenter.AddListener(EventCenter.COM_CommandCharacter,Callable(self,"set_command_state"))
	EventCenter.AddListener(EventCenter.ACT_MOVE,Callable(self,"move_character"))
	EventCenter.AddListener(EventCenter.ACT_TAKE,Callable(self,"character_interact"))
func exit_remove_listener():
	EventCenter.RemoveListener(EventCenter.COM_SetCharacter,Callable(self,"set_character"))
	EventCenter.RemoveListener(EventCenter.COM_CommandCharacter,Callable(self,"set_command_state"))
	EventCenter.RemoveListener(EventCenter.ACT_MOVE,Callable(self,"move_character"))
	EventCenter.RemoveListener(EventCenter.ACT_TAKE,Callable(self,"character_interact"))
func _ready():
	ready_add_listener()
	
func _exit_tree():
	exit_remove_listener()
	
func set_character(arg_character):
	if character!=arg_character:
		if character!=null:
			character.move(Vector2.ZERO)
	character = arg_character
	character.move(move_vector)
	
func set_command_state(arg_on):
	on_command = arg_on
	if on_command:
		character.move(move_vector)
	else:
		character.move(Vector2.ZERO)
		

func move_character(arg_vector):
	move_vector = arg_vector
	if on_command:
		character.move(move_vector)

func character_interact():
	if on_command:
		character.interact()
