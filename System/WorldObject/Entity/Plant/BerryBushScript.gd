extends Entity
#本地组件
@export var Interactor:Node2D
@export var sprite:Sprite2D
@export var stage_score = [2,3,5,8]
@export var sway_animation:AnimationPlayer
#本地变量
enum Age {seedling,sapling,grown,blossom,ripe}
var age
var fruit_count:int
var plant_behavior
var animation_lock:bool = false
#初次生成浆果丛时，有0.6的可能性生成成体（grown）;有0.3的可能性生成结实体（ripe）；有0.1可能性生成幼苗（seedling）
#之后要考虑到季节的关系，随机数阈值会变化
#本地方法
func update_state():
	match age:
		Age.seedling:
			$BerryBushSprite.frame = 0
			Interactor.set_interactable(false)
		Age.sapling:
			$BerryBushSprite.frame = 1
			Interactor.set_interactable(false)
		Age.grown:
			$BerryBushSprite.frame = 2
			Interactor.set_interactable(false)
		Age.blossom:
			match fruit_count:
				1:
					$BerryBushSprite.frame = 3
				2:
					$BerryBushSprite.frame = 4
				3:
					$BerryBushSprite.frame = 5
			Interactor.set_interactable(false)
		Age.ripe:
			match fruit_count:
				1:
					$BerryBushSprite.frame = 6
				2:
					$BerryBushSprite.frame = 7
				3:
					$BerryBushSprite.frame = 8
			Interactor.set_interactable(true)
	
func random_age():
	var age_rand = randf()
	if age_rand<=0.1:
		age = Age.seedling
	elif age_rand<=0.3:
		age = Age.sapling
	elif age_rand<=0.5:
		age = Age.grown
	elif age_rand<=0.7:
		age = Age.blossom
		random_fruit_count()
	else:
		age = Age.ripe
		random_fruit_count()

func random_fruit_count():
		fruit_count = randi_range(1,3)
#外部方法



func _enter_tree():
	EventCenter.AddListener(EventCenter.TIME_QuarterDay,Callable(self,"scoring"))
func _exit_tree():
	EventCenter.RemoveListener(EventCenter.TIME_QuarterDay,Callable(self,"scoring"))
#初始化、物理帧、动画帧
func _ready():
	normalize_position()
	
	plant_behavior = PlantBehavior.new(PlantBehavior.Type.bush)
	
	random_age()
	update_state()
	
	if randf()<=0.5:
		$BerryBushSprite.flip_h = false
	else :
		$BerryBushSprite.flip_h = true

func scoring():
	plant_behavior.scoring()

func sway(arg_direction):
	if !animation_lock:
		match arg_direction:
			Vector2.RIGHT:
				sway_animation.play("sway_right")
			Vector2.LEFT:
				sway_animation.play("sway_left")

func interect(arg_character):
	if age==Age.ripe:
		if arg_character.possession.Add(ItemCenter.find_item_resource("BerryFruit")):
			EventCenter.BroadCast1(EventCenter.COM_PlaySound,"TakeItem")
			fruit_count-=1
			if fruit_count<=0:
				age = Age.grown
		else:
			print("物品栏满了，无法再采集浆果了")
	update_state()
	pass

func lock_animation():
	animation_lock = true

func unlock_animation():
	animation_lock = false
