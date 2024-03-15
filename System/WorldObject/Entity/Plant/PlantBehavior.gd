class_name PlantBehavior
enum Type{bush,tree,weed,crop}
class BushState:
	enum Age{seedling,sapling,grown,blossom,ripe}
	var age
	var score
	var fruit_count
	
	func _init():
		age = Age.seedling
		score = 0
		fruit_count = 0
		
		
		
	func scoring():
		score+=1
		pass
		
	func grow():
		match age:
			Age.seedling: age=Age.sapling
			Age.sapling : age=Age.grown
			Age.grown   : age=Age.blossom
			Age.blossom : age=Age.ripe
			
#		print("bush_grow")
		
class TreeState:
	enum Age{s,a,g,b,r}
	var age
	var fruit_count
	func _init():
		age = Age.s
	func scoring():
#		print("tree_score")
		pass
	func grow():
#		print("tree_grow")
		pass

var state

func _init(arg_type):
	match arg_type:
		Type.bush: state = BushState.new()
func scoring():
	pass
func grow():
	pass
