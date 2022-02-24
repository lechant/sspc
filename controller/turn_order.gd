extends Resource

export var turn_queue = []

class Queue_member:
	var id = null
	var initiative = 0
	var initial_coord = null
	
	func init(id_val,initiative_val,coord):
		id = id_val
		initiative = initiative_val
		initial_coord = coord

func add_to_queue(unit_data,initiative,coord = Vector2(0,0)):
	var unit = Queue_member.new()
	unit.init(unit_data,initiative,coord)
	turn_queue.push_back(unit)
	turn_queue.sort_custom(self,"_sort_initiative")
	
func next():
	var temp = turn_queue.pop_front()
	turn_queue.push_back(temp)
	print(turn_queue)
	
func get_current():
	return turn_queue[0]
	
func _sort_initiative(a,b):	
	if a.initiative > b.initiative:
		return true
	return false
