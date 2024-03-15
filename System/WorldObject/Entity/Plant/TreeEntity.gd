class_name TreeEntity extends Entity
#本地组件
@export var tree_animation:AnimationPlayer
@export var trunk_sprite:Sprite2D
@export var leaf_sprite:Sprite2D
@export var root_sprite:Sprite2D
@export var branch_sprite:Sprite2D
@export var fruit_manager:Node2D
@export var interactor:Interector

var animation_lock:bool = false

func _ready():
	interactor.set_interactable(true)

func sway(arg_direction):
	if !animation_lock:
		lock_animation()
		tree_animation.stop()
		match arg_direction:
			Vector2.RIGHT:
				tree_animation.play("sway_right")
			Vector2.LEFT:
				tree_animation.play("sway_left")

func interect(arg_character):
	if !animation_lock:
		lock_animation()
		tree_animation.stop()
		if arg_character.global_position.x-self.global_position.x<0:
			tree_animation.play("interact_right")
		elif arg_character.global_position.x-self.global_position.x>0:
			tree_animation.play("interact_left")

func transparent(arg_alpha_rate):
	leaf_sprite.self_modulate.a = arg_alpha_rate

func lock_animation():
	animation_lock = true

func unlock_animation():
	animation_lock = false

