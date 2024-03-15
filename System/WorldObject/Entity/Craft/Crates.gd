extends Entity


@export var container:Node
@export var interactor1:Node2D
@export var interactor2:Node2D

func _ready():
	interactor1.set_interactable(true)
	interactor2.set_interactable(true)
	
func interact(_arg_character):
	EventCenter.BroadCast1(EventCenter.GUI_ContainerInventory,container)

