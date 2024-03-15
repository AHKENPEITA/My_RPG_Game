class_name DataStructure
class LinkedList:
	class ListNode:#链表单元，包含对prev\next的引用
		var data
		var prev
		var next
		func _init(arg_data):
			data = arg_data
		func set_next(arg_node):
			next = arg_node
		func set_prev(arg_node):
			prev = arg_node
		func is_head_node():
			return data==null
	var head_node
	
	func _init():
		head_node = ListNode.new(null)
		pass
	
	func get_rear_node():#返回链表的尾部节点
		var flag_node = head_node
		while flag_node.next!=null:
			flag_node = flag_node.next
		return flag_node
		
	func append(arg_data):#以data创建一个节点并添加至尾部
		#为data新建node
		var new_node = ListNode.new(arg_data)
		#把node加入链表
		new_node.prev = get_rear_node()
		get_rear_node().next = new_node
		
	func clear():#清空链表
		head_node.next.prev = null
		head_node.next = null
		
class MapTable:
	class IndexedLinckedList:
		class ListNode:
			var index
			var data
			var prev
			var next
			func _init(arg_index,arg_data):
				index = arg_index
				data = arg_data
		
		var head_node:ListNode
		
		func _init():
			head_node = null
			pass
		
		func has_node()->bool:
			return head_node!=null
		
		func check_index(arg_index)->ListNode:
			if has_node():
				var flag_node = head_node
				while flag_node.index<arg_index:
					if flag_node.next:
						flag_node = flag_node.next
					else:
						return null
				if flag_node.index == arg_index:
					return flag_node
				else:
					return null
			else:
				return null

		func add_node(arg_index,arg_data)->bool:
			if !head_node:
				head_node = ListNode.new(arg_index,arg_data)
				#print(list_node())
				return true
			else:
				if arg_index<head_node.index:
					head_node.prev = ListNode.new(arg_index,arg_data)
					head_node.prev.next = head_node
					head_node = head_node.prev
					#print(list_node())
					return true
				else:
					var flag_node = head_node
					while flag_node.index<arg_index:
						if flag_node.next:
							flag_node = flag_node.next
						else:
							var new_node = ListNode.new(arg_index,arg_data)
							flag_node.next = new_node
							new_node.prev = flag_node
							#print(list_node())
							return true
					#flag_node.index>=arg_index
					if flag_node.index == arg_index:
						printerr("错误使用add_node()方法，不能添加复数个相同index的节点")
						return false
					else:#flag_node.index>arg_index
						flag_node.prev.next = ListNode.new(arg_index,arg_data)
						flag_node.prev.next.prev = flag_node.prev
						flag_node.prev.next.next = flag_node
						flag_node.prev = flag_node.prev.next
						#print(list_node())
						return true
		
		func erase_node(arg_index)->bool:
			var node = check_index(arg_index)
			if node:
				if node.prev && node.next:#at middle place
					node.prev.next = node.next
					node.next.prev = node.prev
					return true
				elif node.next && !node.prev:#at head place
					head_node = node.next
					head_node.prev = null
					return true
				elif !node.next && node.prev:#at rear place
					node.prev.next = null
					node.prev = null
					return true
				elif !node.next && !node.prev:#only one node, @ head & rear place
					head_node = null
					#print("删除节点后链表已清空，等待进一步操作")
					return true
				else:
					printerr("IndexedLinckedList 删除节点时遇到预料之外的情况！")
					return false
			else:
				printerr("There does not exist a node @ index"+str(arg_index))
				return false
		
		##debug
		func print_check_node(arg_index):
			var node = check_index(arg_index)
			if node:
				print(str(str(node.index)+":"+str(node.data)))
			else:
				prints("not ",arg_index," found!")
		
		func list_node():
			if head_node:
				var array = []
				var flag_node = head_node
				array.append (str(str(flag_node.index)+":"+str(flag_node.data)))
				while flag_node.next:
					flag_node = flag_node.next
					array.append (str(str(flag_node.index)+":"+str(flag_node.data)))
				return array
			else:
				return null
		
	var x_list:IndexedLinckedList
	
	func _init():
		x_list = IndexedLinckedList.new()
		pass
	
	func check_coord(arg_coord:Vector2):
		if x_list.has_node():
			var x_node = x_list.check_index(arg_coord.x)
			if x_node:
				var y_list:IndexedLinckedList = x_list.check_index(arg_coord.x).data
				if y_list:
					if y_list.has_node():
						var y_node = y_list.check_index(arg_coord.y)
						if y_node:
							return y_node.data
						else:
							return null#无y_node
					else:
						printerr("MapTable check_coord()出错：预期之外的空y链表")
						return null#y_list为空(不应该)
				else:
					return null#无y_list
			else:
				return null#无x_node
		else:
			#print("MapTable 所查看的表为空，无任何节点")
			return null#x_list为空
	
	func add_to_coord(arg_coord:Vector2,arg_data):
		var x_node = x_list.check_index(arg_coord.x)
		if x_node:
			var y_list:IndexedLinckedList = x_node.data
			if y_list.has_node():
				if y_list.check_index(arg_coord.y):
					printerr("MapTable add_to_coord()出错：该位置有预期之外的节点已占用空间")
					return false
				else:
					y_list.add_node(arg_coord.y,arg_data)
					return true
			else:
				printerr("MapTable check_coord()出错：预期之外的空y链表")
				return false
		else:
			#print("MapTable 为表添加一个新的x节点")
			var y_list = IndexedLinckedList.new()
			y_list.add_node(arg_coord.y,arg_data)
			x_list.add_node(arg_coord.x,y_list)
			return true
	
	func erase_coord(arg_coord:Vector2)->bool:
		if !x_list.has_node():
			printerr("The table is empty, there does not any node could be erased!")
			return false
		else:
			var x_node = x_list.check_index(arg_coord.x)
			if !x_node:
				printerr("Does not find x_node"+str(arg_coord.x)+",erase opetation can not be executed")
				return false
			else:
				var y_list:IndexedLinckedList = x_node.data
				if y_list.erase_node(arg_coord.y):
					if y_list.has_node():
						return true
					else:
						if x_list.erase_node(arg_coord.x):
							if !x_list.has_node():
								#print("The table been erased to empty")
								pass
							return true
						else:
							printerr("Error exists in erase x_node"+str(arg_coord.x))
							return false
				else:
					printerr("Error exists in erase y_node"+str(arg_coord.y)+"in x_node"+str(arg_coord.x))
					return false

	func print_coord(arg_coord:Vector2):
		var result = check_coord(arg_coord)
		if result:
			print(str(arg_coord)+":"+str(result))
		else:
			print("The coord"+str(arg_coord)+"is empty!")
	
	func print_table():
		if x_list.has_node():
			var flag_x_node = x_list.head_node
			var y_list:IndexedLinckedList = flag_x_node.data
			print("<"+str(flag_x_node.index)+">"+str(y_list.list_node()))
			while flag_x_node.next!=null:
				flag_x_node = flag_x_node.next
				y_list = flag_x_node.data
				print("<"+str(flag_x_node.index)+">"+str(y_list.list_node()))
		else:
			print("The table is empty")
	

