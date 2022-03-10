class_name BaseEnemy
extends unit

const directions = [Vector2.RIGHT,Vector2.LEFT,Vector2.UP,Vector2.DOWN,Vector2(1,1),Vector2(-1,-1),Vector2(-1,1),Vector2(1,-1)]

func _ready():
	pass
	
func create_priority_list():
	var unit_list = []
	var unit_pos = path_tiles.world_to_map(global_position)
	for target in get_unit_manager().get_all_units("Player"):
		var priority = 0
		var target_pos = path_tiles.world_to_map(target.global_position)
		var path_size = get_unit_manager().find_unit_path_to(self,target_pos).size()
		if !path_size:
			continue
		priority -= path_size/2
		priority += target.curr_stats["health"]/3 
		unit_list.push_back({"id":target.character_id,"priority":priority})
	pass
	
func get_adjacent(position):
	var adjacent_points = []
	for direction in directions:
		var point = position + direction
		var unit = get_unit_manager().get_unit_at_position(position)
		var is_occupied = (unit && unit.character_id != character_id)
		if is_occupied:
			continue
		var priority = 0
		adjacent_points.push_back({"position":point,"priority":priority})
	return adjacent_points
	
func is_adjacent_to(target_position):
	var unit_position = path_tiles.world_to_map(global_position)
	for direction in directions:
		var point = unit_position + direction
		if point == target_position:
			return true
	return false
