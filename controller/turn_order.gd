#extends Resource
#
#export var turn_queue = []
#
#class Queue_member:
#	var id = null
#	var initiative = 0
#	var initial_coord = null
#
#	func init(id_val,initiative_val,coord):
#		id = id_val
#		initiative = initiative_val
#		initial_coord = coord
#
#func add_to_queue(unit_data,initiative,coord = Vector2(0,0)):
#	var unit = Queue_member.new()
#	unit.init(unit_data,initiative,coord)
#	turn_queue.push_back(unit)
#	turn_queue.sort_custom(self,"_sort_initiative")
#
#func next():
#	var temp = turn_queue.pop_front()
#	turn_queue.push_back(temp)
#	print(turn_queue)
#
#func get_current():
#	return turn_queue[0]
#
#func _sort_initiative(a,b):	
#	if a.initiative > b.initiative:
#		return true
#	return false
#
#func printToString():
#	for member in turn_queue:
#		print("id: " + String(member.id) + ", initiative: " + String(member.initiative))

extends Resource

var unit_list = []
var turn_queue = []
var turn_history = []
var cycle_index = 0
var rng = RandomNumberGenerator.new()
var active_unit_id = null

func add_to_queue(id,type,initial_coord = Vector2(0,0)):
	if _units_has_id(id):
		return
	var initiative = rng.randi_range(0,20)
	var unit = {"id":id,"initiative":initiative,"type":type,"initial_coord":initial_coord}
	unit_list.push_back(unit)
	turn_queue.push_back({"id":id,"initiative":initiative,"type":type})

func cycle_unit_list(type = null,step = false):
	var filtered_units = _units_filter_type(type)
	if cycle_index >= filtered_units.size():
		cycle_index = 0
	var unit = filtered_units[cycle_index]
	if step:
		cycle_index += 1
	return unit

func next_in_queue():
	active_unit_id = null
	var unit = turn_queue.pop_front()
	turn_queue.push_back(unit)
	return unit
	
func get_queue_current():
	return turn_queue[0]
	
#set a specific id as the current active id
func set_active(id):
	print("set active:" + str(id))
	if turn_history.has(id):
		return false
	active_unit_id = id
	turn_history.push_back(id)
	return true
	
func get_unit(id):
	for unit in unit_list:
		if unit['id'] == id:
			return unit
	return false
	
func _units_filter_type(type):
	if !type:
		return unit_list
	var filter_result = []
	for unit in unit_list:
		if unit['type'] == type:
			filter_result.push_back(unit)
	return filter_result

func _units_has_id(id):
	for unit in unit_list:
		if unit['id'] == id:
			return true
	return false

func _load_turn_order():
	if !turn_queue:
		for unit in unit_list:
			turn_queue.push_back({"type":unit['type'],"initiative":unit['initiative']})
		turn_queue.sort_custom(self,"_sort_unit_initiative")

func _sort_unit_initiative(a,b):
	if a['initiative'] < b['initiative']:
		return a

func printToString():
	for member in turn_queue:
		print("id: " + String(member.id) + ", initiative: " + String(member.initiative))
