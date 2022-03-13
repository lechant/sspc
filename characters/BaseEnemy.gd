class_name BaseEnemy
extends unit

const directions = [Vector2.RIGHT,Vector2.LEFT,Vector2.UP,Vector2.DOWN,Vector2(1,1),Vector2(-1,-1),Vector2(-1,1),Vector2(1,-1)]
export var alert = false setget set_alert

func _ready():
	pass
	
func create_unit_priority_list():
	var unit_list = []
	var unit_pos = path_tiles.world_to_map(global_position)
	for target in get_unit_manager().get_all_units("player"):
		var priority = 0
		var target_pos = path_tiles.world_to_map(target.global_position)
		var path_size = get_unit_manager().find_unit_path_to(self,target_pos).size()
		if !path_size:
			continue
		priority -= path_size
		priority += target.curr_stats["health"]/2
		#introduce randomness
		priority += rng.randi_range(0,2)
		unit_list.push_back({"id":target.character_id,"priority":priority,"unit_pos":target_pos})
	unit_list.sort_custom(self,"sort_by_priority")
	return unit_list
	
func create_area_priority_list(target_position,max_range):
	var area_list = []
	for x in range(target_position.x - max_range, target_position.x + max_range + 1):
		for y in range(target_position.y - max_range, target_position.y + max_range + 1):
			var point := Vector2(x,y)
			var priority = 0
			if !path_tiles.get_used_cells().has(point) || point == target_position:
				continue
			priority -= path_tiles.get_astar_path(target_position,point).size()/2
			priority += rng.randi_range(0,2)
			area_list.push_back({"priority":priority,"position":point})
	area_list.sort_custom(self,"sort_by_priority")
	return area_list
	
#func get_adjacent(position):
#	var adjacent_points = []
#	for direction in directions:
#		var point = position + direction
#		var unit = get_unit_manager().get_unit_at_position(position)
#		var is_occupied = (unit && unit.character_id != character_id)
#		if is_occupied:
#			continue
#		adjacent_points.push_back(point)
#	return adjacent_points
#
#func is_adjacent_to(target_position):
#	var unit_position = path_tiles.world_to_map(global_position)
#	for direction in directions:
#		var point = unit_position + direction
#		if point == target_position:
#			return true
#	return false
	
func sort_highest_priority(list):
	list.sort_custom(self,"sort_by_priority")
	return list

func sort_by_priority(a,b):
	if a['priority'] > b['priority']:
		return true
	return false

func move_to_point(point):
	var world_position = path_tiles.map_to_world(point)
	if get_unit_manager().move_unit(world_position,true):
		return true
	pass

func set_alert(val):
	if alert:
		return
	for unit in get_unit_manager().get_all_units("enemy"):
		if path_tiles.get_astar_path(global_position,unit.global_position).size() < 5:
			unit.alert = true
	alert = val
