extends BaseEnemy
	
func sort_highest_priority(list):
	list.sort_custom(self,"sort_by_priority")
	return list

func sort_by_priority(a,b):
	if a['priority'] > b['priority']:
		return true
	return false
	
func _handle_move_towards(points):
	for adjacent_point in points:
		var world_position = path_tiles.map_to_world(adjacent_point['position'])
		if get_unit_manager().move_unit(world_position,true):
			return true
			break
	return false

func turn_actions():
	var units = get_unit_manager().get_all_units("player")
	var self_pos = path_tiles.world_to_map(self.position)
	var unit_priority = []
	for unit in units:
		var priority_val = 0
		var unit_pos = path_tiles.world_to_map(unit.position)
		var path_to_target = path_tiles.get_astar_path(self_pos,unit_pos)
		if path_to_target:
			 priority_val -= path_to_target.size()/2
		else:
			continue
		if unit.curr_stats['health'] > 0:
			priority_val -= unit.base_stats['health']/3
		else:
			continue
		unit_priority.push_back({"id":unit.character_id,"priority":priority_val,"unit_pos":unit_pos})
	if unit_priority:
		#if available targets are found, move to them
		var target_unit = sort_highest_priority(unit_priority)[0]['unit_pos']
		var adjacent_points = get_adjacent(target_unit)
		_handle_move_towards(adjacent_points)
		#attack them lol
		var target_unit_world_position = path_tiles.map_to_world(target_unit)
		var target_unit_node = get_unit_manager().get_unit_at_position(target_unit_world_position)
		yield(self,"move_complete")
		if target_unit_node && is_adjacent_to(target_unit):
			target_unit_node.damage(3)
			
#func movement_area_scan(init,target,max_range):
#	var movement_area_tiles = []
#	for x in range(init.x - max_range - 1, init.x + max_range):
#		for y in range(init.y - max_range - 1, init.y + max_range):
#			var point := Vector2(x,y)
#			if !path_tiles.get_used_cells().has(point):
#				continue
#			var astar_path = path_tiles.get_astar_path(init,point)
#			if !astar_path || astar_path.size() > max_range:
#				continue
#			var priority = 0
#			var astar_path_target = path_tiles.get_astar_path(point,target)
#			if !astar_path_target:
#				continue
#			priority -= astar_path_target.size()
#			movement_area_tiles.push_back(point)
#	return movement_area_tiles
