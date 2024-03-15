extends CharacterBody2D
#导入本地组件
@export var possession:Node
@export var BodyAnimationPlayer:AnimationPlayer
@export var dialog_box:Label
#导入外部组件
#参数
@export var WalkSpeed:int = 60
var occupy_location:Vector2
var front_location:Vector2
var interactor:Node
#变量
var move_vector = Vector2.ZERO
var direction_vector = Vector2.DOWN
#信号
signal signal_body_position_direction
#本地方法
func _ready():
	EventCenter.AddListener(EventCenter.COM_ReloadInteractor,Callable(self,"reload_interactor"))

func _exit_tree():
	EventCenter.RemoveListener(EventCenter.COM_ReloadInteractor,Callable(self,"reload_interactor"))

#初始化、物理帧、动画帧
func _physics_process(_delta):
	velocity = move_vector.normalized()*WalkSpeed
	move_and_slide()
	
func _process(_delta):
	update_location()
	update_animation()

#受控方法:
func move(arg_vector):
	move_vector = arg_vector

func interact():
	if interactor:
		interactor.interact(self)
		reload_interactor()


#主体方法
func update_animation():
	if move_vector!=Vector2.ZERO:
		if (move_vector.x>0):
			BodyAnimationPlayer.play("WalkRight")
		elif(move_vector.x<0):
			BodyAnimationPlayer.play("WalkLeft")
		elif(move_vector.y<0):
			BodyAnimationPlayer.play("WalkUp")
		elif(move_vector.y>0):
			BodyAnimationPlayer.play("WalkDown")
		direction_vector = move_vector
	else :
		match direction_vector:
			Vector2.RIGHT:
				BodyAnimationPlayer.play("IdleRight")
			Vector2.LEFT:
				BodyAnimationPlayer.play("IdleLeft")
			Vector2.UP:
				BodyAnimationPlayer.play("IdleUp")
			Vector2.DOWN:
				BodyAnimationPlayer.play("IdleDown")
	#由自身_process每帧调用

func get_entity_location(entity)->Vector2:
	var x=(floorf(entity.global_position.x/16))
	var y=(floorf(entity.global_position.y/16))
	return Vector2(x,y)

func update_location():
	if occupy_location != get_entity_location(self) || front_location != get_entity_location(self)+direction_vector:
		occupy_location = get_entity_location(self)
		front_location = occupy_location+direction_vector
		reload_interactor()
	
func reload_interactor():
	var temp_interactor 
	temp_interactor = Global.entity_container.get_interactor(front_location)
	interactor = null
	if temp_interactor:
		if temp_interactor.interactable:
			interactor = temp_interactor
	temp_interactor = Global.entity_container.get_interactor(occupy_location)
	if temp_interactor:
		if temp_interactor.interactable:
			interactor = temp_interactor

func _on_storage_storage_overflow():
	dialog_box.pop_dialog("我物品栏满了，拿不下它。")
