extends Resource

var ability_data = load("res://controller/ability_data.tres")

var target_arr = []
var target_param = null
var active_skill = ""
var unit_pos = null

var character_manager = null 
var path_tiles = null
var highlight_tiles = null

func set_skill(manager,pos,name):
	target_arr = []
	var param = ability_data.get_selection_param(manager.get_active_unit().character_id,name)
	if !param:
		return false
	active_skill = name
	character_manager = manager
	target_param = param
	highlight_tiles = character_manager.highlight_tiles
	path_tiles = character_manager.path_tiles
	unit_pos = path_tiles.world_to_map(pos)
	skill_highlight()
	
func add_selection(mouse_pos):
	var method_name = target_param['type'] + '_select'
	var map_pos = path_tiles.world_to_map(mouse_pos)
	var unit_to_pos = get_range(unit_pos,map_pos)
	if target_param['range'] && unit_to_pos && target_param['range'] < unit_to_pos:
		return false
	if has_method(method_name):
		var result = call(method_name,map_pos)
		if !result:
			return false
		target_arr.push_back(result)
		if target_arr.size() >= target_param['limit']:
			character_manager.selection_callback(target_arr)
	
func point_select(map_pos):
	if target_param['flags'].has("unoccupied") && is_occupied(map_pos):
		return false
	if !target_param['flags'].has("stacking") && target_arr.has(map_pos):
		return false
	return map_pos

func unit_select(map_pos):
	var world_pos = path_tiles.map_to_world(map_pos)
	var unit = character_manager.get_unit_at_position(world_pos)
	if !unit || !target_param['targets'].has(unit.base_stats['type']):
		return false
	return unit
	
func directional_area_select(mouse_pos):
	pass
	
func radial_area_select(mouse_pos):
	pass

func skill_highlight():
	var type = target_param['type']
	if (type == 'point' || type == 'unit')  && target_param.has('range'):
		highlight_tiles.radial_highlight(get_unit_position(),target_param['range'])	

func mouse_move_highlight(mouse_pos):
	pass
	
func get_unit_position():
	return character_manager.get_active_unit().position
	
func is_occupied(map_pos):
	var world_pos = path_tiles.map_to_world(map_pos)
	var unit = character_manager.get_unit_at_position(world_pos)
	if unit:
		return unit 
	else:
		return false
		
func get_range(position,target,unit_blocking = false):
	var path = path_tiles.get_astar_path(position,target)
	if path:
		return path.size()
	else:
		return false
