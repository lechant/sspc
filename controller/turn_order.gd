extends Resource

export var turn_queue = []
export var round_queue = []
var round_count = 0

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
	if round_queue.size() == 0:
		round_count += 1
		round_queue = turn_queue.duplicate(true)
	print(round_queue)
	var temp = round_queue.pop_front()
	
func get_current():
	if round_queue.size() == 0:
		round_count += 1
		round_queue = turn_queue.duplicate(true)
	return round_queue[0]
	
func _sort_initiative(a,b):	
	if a.initiative > b.initiative:
		return true
	return false
